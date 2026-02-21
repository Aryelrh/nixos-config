-- lua/plugins/bufferline.lua
return {
  {
    "akinsho/bufferline.nvim",
    event = "BufAdd",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("bufferline").setup({
        options = {
          mode = "buffers",
          separator_style = "thick",
          show_buffer_close_icons = true,
          show_close_icon = false,
          diagnostics = "nvim_lsp",
          indicator = { style = "none" },
          enforce_regular_tabs = true,
          tab_size = 20,
          max_name_length = 30,
          -- Hace que los tabs se distribuyan en todo el ancho
          padding = 1,
          always_show_bufferline = true,
        },
      })

      -- Navegación entre buffers
      local keymap = vim.keymap.set
      local opts = { noremap = true, silent = true }
      keymap("n", "<Tab>", ":BufferLineCycleNext<CR>", opts)
      keymap("n", "<S-Tab>", ":BufferLineCyclePrev<CR>", opts)
      -- No mapear leader-x aquí, está definido en keymaps.lua
    end,
  },
}
