-- modules/home/nvim/lua/config/lazy.lua
return require("lazy").setup({
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd("colorscheme tokyonight")
    end,
  },
  { "nvim-lua/plenary.nvim", lazy = true },
}, {
  -- Forces to use a mutable path to generate /lazy-lock.json
  lockfile = vim.fn.stdpath("data") .. "/lazy-lock.json",
  defaults = { lazy = true },
  install = { colorscheme = { "tokyonight" } },
  checker = { enabled = true, notify = false },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip", "zipPlugin", "netrwPlugin", "tarPlugin",
      },
    },
  },
})
