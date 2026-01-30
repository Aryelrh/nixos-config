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
          view = "cmdline_popup",
          format = {
            cmdline = { icon = " ", lang = "vim" },
            search_down = { icon = " 🔍 ", lang = "regex" },
            search_up = { icon = " 🔍 ", lang = "regex" },
            filter = { icon = " ", lang = "vim" },
            lua = { icon = " ", lang = "lua" },
            help = { icon = " ", lang = "vim" },
          },
        },
        popupmenu = {
          enabled = true,
          backend = "nui",
        },
        routes = {
          {
            filter = {
              event = "msg_show",
              any = {
                { find = "%d+L, %d+B" },
                { find = "; after #%d+" },
                { find = "; before #%d+" },
              },
            },
            view = "mini",
          },
        },
        views = {
          cmdline_popup = {
            backend = "popup",
            relative = "editor",
            align = "center",
            border = {
              style = "rounded",
              highlight = "NormalFloat",
              text = {
                top = " Command ",
              },
            },
            size = {
              width = 60,
              height = "auto",
            },
            win_options = {
              winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
            },
            enter = true,
            zindex = 200,
          },
          popupmenu = {
            backend = "nui",
            relative = "editor",
            align = "center",
            size = {
              width = 60,
              height = 10,
            },
            border = {
              style = "rounded",
              padding = { 0, 1 },
            },
            win_options = {
              winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
            },
          },
        },
      })

      -- Optional: Setup notify for better notifications
      require("notify").setup({
        background_colour = "#000000",
      })
    end,
  },
}
