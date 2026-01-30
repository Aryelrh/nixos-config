-- ~/nixos-config/modules/home/nvim/lua/plugins/neotree.lua
return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    cmd = "Neotree",
    keys = {
      { "<leader>t", "<cmd>Neotree toggle<CR>", { desc = "Toggle Neotree" } },
    },
    config = function()
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
      require("neo-tree").setup({
        close_if_last_window = false,
        enable_git_status = true,
        enable_diagnostics = true,
        filesystem = {
          follow_current_file = {
            enabled = true,
            leave_dirs_open = false,
          },
          filtered_items = {
            hide_dotfiles = false,
            hide_gitignored = true,
          },
        },
        window = {
          width = 30,
          position = "left",
          mappings = {
            ["<space>"] = "toggle_node",
            ["<CR>"] = "open",
            ["<Esc>"] = "cancel",
            ["c"] = "add",
            ["d"] = "delete",
            ["r"] = "rename",
          },
        },
      })
    end,
  },
}
