-- ~/nixos-config/modules/home/nvim/lua/plugins/noice.lua
return {
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    config = function()
      require("noice").setup({
        lsp = {
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
        },
        presets = {
          bottom_search = true,
          command_palette = true,
          long_message_to_split = true,
          inc_rename = false,
          lsp_doc_border = false,
        },
        cmdline = {
          enabled = true,
          view = "cmdline_popup",
        },
        routes = {
          {
            filter = {
              event = "msg_show",
              any = {
                { find = "%d+L, %d+B" },
                { find = "; after #%d+" },
                { find = "; before #%d+" },
                { find = "E37" },
              },
            },
            view = "mini",
          },
          {
            filter = {
              event = "notify",
              find = "No information available",
            },
            opts = { skip = true },
          },
        },
        commands = {
          history = {
            view = "split",
            opts = { enter = true, format = "details" },
            filter = {
              any = {
                { event = "notify" },
                { error = true },
                { warning = true },
              },
            },
          },
          last = {
            view = "popup",
            opts = { enter = true, format = "details" },
          },
          errors = {
            view = "popup",
            opts = { enter = true, format = "details" },
            filter = { error = true },
          },
        },
        views = {
          notify = {
            replace = true,
            merge = true,
          },
          hover = {
            view = "popup",
          },
          split = {
            view = "split",
            enter = true,
          },
          popup = {
            backend = "popup",
            relative = "editor",
            align = "center",
            border = {
              style = "rounded",
              padding = { 0, 1 },
            },
            size = {
              width = "60%",
              height = "auto",
            },
            win_options = {
              winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
              wrap = true,
            },
          },
        },
      })

      -- Setup notify for better notifications
      require("notify").setup({
        background_colour = "#000000",
        top_down = false,
      })
    end,
  },
}
