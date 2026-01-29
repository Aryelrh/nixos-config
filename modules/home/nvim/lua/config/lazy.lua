-- lua/config/lazy.lua
return require("lazy").setup({
  spec = {
    { import = "plugins" },
  },
  defaults = { lazy = true },
  -- Forces lockfile to mutable path (requirement for NixOS)
  lockfile = vim.fn.stdpath("data") .. "/lazy-lock.json",
  install = { colorscheme = { "rose-pine" } },
  checker = { enabled = true, notify = false },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip", "zipPlugin", "netrwPlugin", "tarPlugin",
        "matchit", "matchparen", "tarPlugin", "tohtml",
        "tutor", "zipPlugin",
      },
    },
  },
})
