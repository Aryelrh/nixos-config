-- lua/plugins/ui.lua
return {
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = false,
    priority = 1000,
    config = function()
      require("rose-pine").setup({ variant = "main" })
      vim.cmd("colorscheme rose-pine")
    end,
  },
  { "nvim-tree/nvim-web-devicons", lazy = true },
}

