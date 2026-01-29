-- modules/home/nvim/lua/config/lazy.lua
return require("lazy").setup({
  -- Plugin de prueba: tema visual
  {
    "folke/tokyonight.nvim",
    lazy = false,  -- Cargar inmediatamente
    priority = 1000,  -- Alta prioridad para temas
    config = function()
      vim.cmd("colorscheme tokyonight")
    end,
  },

  -- UI mínima para Lazy
  { "nvim-lua/plenary.nvim", lazy = true },
}, {
  -- Opciones de Lazy
  defaults = { lazy = true },
  install = { colorscheme = { "tokyonight" } },
  checker = { enabled = true, notify = false },  -- Notifica actualizaciones en background
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip", "zipPlugin", "netrwPlugin", "tarPlugin",
      },
    },
  },
})
