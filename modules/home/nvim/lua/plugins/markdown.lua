-- lua/plugins/markdown.lua
return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      enabled = true,
      preset = "obsidian",
      file_types = { "markdown" },
      render_modes = { "n", "c", "t" },
      anti_conceal = {
        enabled = true,
        above = 0,
        below = 0,
      },
    },
    config = function(_, opts)
      require("render-markdown").setup(opts)
      -- Auto-enable rendering on markdown files
      require("render-markdown").enable()
    end,
  },
}
