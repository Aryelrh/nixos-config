-- lua/plugins/explorer.lua
return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- Ya lo tienes instalado ✅
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("neo-tree").setup({
        close_if_last_window = true, -- Cierra Neo-tree si es la última ventana
        popup_border_style = "rounded",
        enable_git_status = true,
        enable_diagnostics = true,

        filesystem = {
          filtered_items = {
            visible = false, -- Oculta archivos ignorados por .gitignore
            hide_dotfiles = false,
            hide_gitignored = true,
            hide_hidden = false, -- Muestra archivos ocultos (.env, etc.)
            hide_by_name = {
              ".git",
              "__pycache__",
              "node_modules",
            },
          },
          follow_current_file = {
            enabled = true,   -- Expande árbol al abrir archivo
            leave_dirs_open = true,
          },
          use_libuv_file_watcher = true, -- Actualización en tiempo real
        },

        window = {
          position = "left",
          width = 30,
          mapping_options = {
            noremap = true,
            nowait = true,
          },
          mappings = {
            ["<space>"] = "toggle_node",     -- Toggle expansión
            ["<2-LeftMouse>"] = "open",      -- Doble click para abrir
            ["<cr>"] = "open",               -- Enter para abrir
            ["<esc>"] = "revert_preview",    -- Esc para cerrar preview
            ["P"] = { "toggle_preview", config = { use_float = true } },
            ["l"] = "open",                  -- l = abrir (como en ranger)
            ["h"] = "close_node",            -- h = cerrar nodo
            ["H"] = "expand_all",            -- H = expandir todo
            ["I"] = "collapse_all",          -- I = contraer todo
            ["/"] = "fuzzy_finder",          -- / para búsqueda fuzzy
            ["f"] = "filter_on_submit",      -- f para filtrar
            ["gf"] = "git_status",           -- gf para ver estado Git
            ["a"] = "add",                   -- a para crear archivo/carpeta
            ["d"] = "delete",                -- d para borrar
            ["r"] = "rename",                -- r para renombrar
            ["c"] = "copy",                  -- c para copiar
            ["m"] = "move",                  -- m para mover
            ["y"] = "copy_path",             -- y para copiar ruta
            ["Y"] = "copy_path_relative",    -- Y para copiar ruta relativa
            ["p"] = "paste",                 -- p para pegar
            ["s"] = "system_open",           -- s para abrir con app del sistema
            ["S"] = "split_with_window_picker",
            ["t"] = "open_tab",
            ["C"] = "close_all_subnodes",
            ["z"] = "refresh",               -- z para refrescar
            ["?"] = "show_help",
            ["q"] = "close_window",          -- q para cerrar ventana
          },
        },

        default_component_configs = {
          indent = {
            padding = 1, -- Espacio extra para indentación visual
          },
          icon = {
            folder_closed = "",
            folder_open = "",
            folder_empty = "󰜌",
          },
          modified = {
            symbol = " ",
          },
          git_status = {
            symbols = {
              added = " ",
              deleted = " ",
              modified = " ",
              renamed = " ",
              untracked = " ",
              ignored = " ",
              unstaged = " ",
              staged = " ",
              conflict = " ",
            },
          },
        },
      })

      -- Keymaps globales para abrir Neo-tree
      vim.keymap.set("n", "<leader>e", function()
        require("neo-tree.command").execute({ toggle = true, dir = require("neo-tree.utils").get_cwd() })
      end, { desc = "Toggle Neo-tree" })

      vim.keymap.set("n", "<leader>E", function()
        require("neo-tree.command").execute({ action = "show", toggle = true, reveal = true })
      end, { desc = "Reveal current file in Neo-tree" })
    end,
  },
}
