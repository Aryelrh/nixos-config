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
        event_handlers = {
          {
            event = "file_opened",
            handler = function()
              require("neo-tree.command").execute({ action = "close" })
            end,
          },
        },
        filesystem = {
          follow_current_file = { enabled = false },
          filtered_items = {
            hide_dotfiles = false,
            hide_gitignored = true,
          },
        },
        window = {
          width = 30,
          position = "left",
          mappings = {
            ["<CR>"] = function(state)
              local node = state.tree:get_node()
              if node.type == "file" then
                local path = node.path
                -- Focus a window that is not Neotree
                -- to avoid Neovim create a buffer [No Name]
                for _, win in ipairs(vim.api.nvim_list_wins()) do
                  if vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "neo-tree" then
                    vim.api.nvim_set_current_win(win)
                    break
                  end
                end
                vim.cmd("edit " .. vim.fn.fnameescape(path))
              else
                state.commands["toggle_node"](state)
              end
            end,
            ["<space>"] = "toggle_node",
            ["<Esc>"] = "cancel",
            ["c"] = "add",
            ["d"] = "delete",
            ["r"] = "rename",
            ["R"] = "set_root",
          },
        },
      })

      -- Terminal in new buffer
      vim.api.nvim_create_user_command("ToggleTerminalCwd", function()
        local cwd = vim.fn.getcwd()
        local ok, result = pcall(function()
          return require("neo-tree.sources.manager").get_state("filesystem").path
        end)
        if ok and result then cwd = result end

        local shell = os.getenv("SHELL") or "bash"
        vim.cmd("enew")
        vim.fn.termopen("cd " .. vim.fn.shellescape(cwd) .. " && " .. shell)
        vim.cmd("startinsert")
      end, {})
    end,
  },
}


