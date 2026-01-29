-- lua/plugins/treesitter.lua
return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        -- Auto language install
        ensure_installed = {
          "lua", "vim", "vimdoc", "query",
          "python", "javascript", "typescript", "tsx", "css", "html",
          "rust", "cpp", "java", "json", "yaml", "markdown", "markdown_inline",
        },

        -- Auto Highlighting
        highlight = {
          enable = true,
          disable = function(lang, buf)
            -- Desable in large buffers (>100k lines)
            local max_filesize = 100 * 1024 -- 100KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
              return true
            end
          end,
        },

        -- Indentation
        indent = { enable = true },

        -- Inteligent autopairs (ej: () {} [])
        autopairs = { enable = true },

        -- Incremental selection (visual scopes with =)
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<CR>",      
            node_incremental = "<CR>",   
            scope_incremental = "<TAB>",  
            node_decremental = "<S-TAB>",
          },
        },

        -- Textobjects to move through the code (ej: "inner function")
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
            },
          },
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
              ["]m"] = "@function.outer",
              ["]]"] = "@class.outer",
            },
            goto_next_end = {
              ["]M"] = "@function.outer",
              ["]["] = "@class.outer",
            },
            goto_previous_start = {
              ["[m"] = "@function.outer",
              ["[["] = "@class.outer",
            },
            goto_previous_end = {
              ["[M"] = "@function.outer",
              ["[]"] = "@class.outer",
            },
          },
        },
      })

      -- Util commands
      vim.api.nvim_create_user_command("TSInstallAll", function()
        require("nvim-treesitter.install").update({ with_sync = true })
      end, {})
    end,
  },

  {
    "windwp/nvim-ts-autotag",
    ft = { "html", "xml", "tsx", "jsx" },
    config = true,
  },
}
