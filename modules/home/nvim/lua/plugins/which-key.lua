return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    -- which-key configuration options
    spec = {
      { "<leader>f", group = "file/find" },
      { "<leader>c", group = "code" },
      { "<leader>x", group = "diagnostics/quickfix" },
    },
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
}
