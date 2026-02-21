-- lua/plugins/bufferline.lua
return {
  {
    "akinsho/bufferline.nvim",
    event = "BufAdd",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      -- Calculate the tab size dynamic
      local function dynamic_tab_size()
        local bufs = vim.fn.getbufinfo({ buflisted = 1 })
        local count = math.max(#bufs, 1)
        local width = math.floor((vim.o.columns - 4) / count) - 2
        return math.max(width, 10)
      end

      require("bufferline").setup({
        options = {
          mode = "buffers",
          separator_style = "thick",
          show_buffer_close_icons = true,
          show_close_icon = false,
          diagnostics = "nvim_lsp",
          indicator = { style = "none" },
          enforce_regular_tabs = false,
          tab_size = dynamic_tab_size(),
          max_name_length = 40,
          always_show_bufferline = true,
        },
      })

      -- Update the buffer tab size depending on the number of buffers
      local group = vim.api.nvim_create_augroup("BufferlineDynamicSize", { clear = true })

      local function recalculate()
        local bufs = vim.fn.getbufinfo({ buflisted = 1 })
        local count = math.max(#bufs, 1)
        local width = math.floor((vim.o.columns - 4) / count) - 2
        local size = math.max(width, 10)
        require("bufferline").setup({
          options = {
            mode = "buffers",
            separator_style = "thick",
            show_buffer_close_icons = true,
            show_close_icon = false,
            diagnostics = "nvim_lsp",
            indicator = { style = "none" },
            enforce_regular_tabs = false,
            tab_size = size,
            max_name_length = 40,
            always_show_bufferline = true,
          },
        })
      end

      vim.api.nvim_create_autocmd({ "BufAdd", "VimResized" }, {
        group = group,
        callback = function()
          vim.schedule(recalculate)
        end,
      })

      -- BufDelete: wait to the buffer to be deleted to update the tab size
      vim.api.nvim_create_autocmd("BufDelete", {
        group = group,
        callback = function()
          vim.schedule(recalculate)
        end,
      })

      -- Buffer navigation
      local keymap = vim.keymap.set
      local opts = { noremap = true, silent = true }
      keymap("n", "<Tab>", ":BufferLineCycleNext<CR>", opts)
      keymap("n", "<S-Tab>", ":BufferLineCyclePrev<CR>", opts)
    end,
  },
}
