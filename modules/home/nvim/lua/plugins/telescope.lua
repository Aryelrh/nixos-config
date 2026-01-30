-- lua/plugins/telescope.lua
return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "Telescope",
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Find files" } },
      { "<leader>fg", "<cmd>Telescope live_grep<CR>", { desc = "Live grep" } },
      { "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "Buffers" } },
      { "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "Help tags" } },
      { "<leader>fr", "<cmd>Telescope oldfiles<CR>", { desc = "Recent files" } },
    },
    config = function()
      require("telescope").setup({
        defaults = {
          mappings = {
            i = {
              ["<C-u>"] = false,
              ["<C-d>"] = false,
            },
          },
        },
      })
    end,
  },

  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
    cond = function()
      return vim.fn.executable("make") == 1
    end,
    config = function()
      require("telescope").load_extension("fzf")
    end,
  },
}
