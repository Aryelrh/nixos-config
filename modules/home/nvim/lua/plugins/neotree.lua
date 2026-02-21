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
            ["<CR>"] = function(state)
              local node = state.tree:get_node()
              if node.type == "file" then
                require("neo-tree.sources.filesystem.commands").open(state)
                vim.schedule(function()
                  vim.cmd("Neotree close")
                end)
              else
                require("neo-tree.sources.filesystem.commands").toggle_directory(state)
              end
            end,
            ["<Esc>"] = "cancel",
            ["c"] = "add",
            ["d"] = "delete",
            ["r"] = "rename",
            -- Expand/Collapse all
            ["E"] = function(state)
              local renderer = require("neo-tree.ui.renderer")
              for _, node in ipairs(state.tree:get_nodes()) do
                if node:has_children() then
                  node:expand()
                end
              end
              renderer.redraw(state)
            end,
            ["W"] = function(state)
              local renderer = require("neo-tree.ui.renderer")
              for _, node in ipairs(state.tree:get_nodes()) do
                if node:has_children() then
                  node:collapse()
                end
              end
              renderer.redraw(state)
            end,
            -- Set as root
            ["R"] = "set_root",
            -- Reset root to home
            ["<leader>h"] = function(state)
              require("neo-tree.sources.filesystem").navigate(state, vim.fn.expand("~"))
            end,
            -- Open terminal in current directory
            ["T"] = function(state)
              local node = state.tree:get_node()
              local path = node.path
              if node.type == "file" then
                path = node.parent.path
              end
              vim.cmd("execute 'split | terminal cd " .. vim.fn.fnameescape(path) .. " && $SHELL'")
            end,
          },
        },
      })

      -- Command to toggle terminal at Neotree root
      vim.api.nvim_create_user_command("ToggleTerminalCwd", function()
        local cwd = vim.fn.getcwd()

        -- Try to get Neotree's current path if it's open
        local success, result = pcall(function()
          local manager = require("neo-tree.sources.manager")
          local source = manager.get_state("filesystem")
          return source.path
        end)

        if success and result then
          cwd = result
        end

        -- Open terminal in a new buffer (no split)
        local shell = os.getenv("SHELL") or "bash"
        vim.cmd("enew")
        vim.fn.termopen("cd " .. vim.fn.shellescape(cwd) .. " && " .. shell)
        vim.cmd("startinsert")
      end, {})
    end,
  },
}

