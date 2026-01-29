-- lua/plugins/ui.lua
return {
  -- Rosé Pine official theme
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = false,
    priority = 1000,
    config = function()
      require("rose-pine").setup({
        -- Variants: "main" (default), "moon", "dawn"
        variant = "main",
        dark_variant = "main",
        bold_vert_split = false,
        dim_nc_background = false,
        disable_background = false,
        disable_float_background = false,
        disable_italics = false,

        -- Custom colour groups (optional)
        groups = {
          -- Ex: highlight comments soft
          -- comment = { fg = "rose-pine.muted" },
        },

        -- Popular plugins integration
        plugins = {
          cmp = true,
          gitsigns = true,
          telescope = true,
          notify = false,
          mini = false,
        },
      })
      vim.cmd("colorscheme rose-pine")
    end,
  },

  -- Icons
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
  },
}
