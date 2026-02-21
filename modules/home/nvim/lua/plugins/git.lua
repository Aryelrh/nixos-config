-- lua/plugins/git.lua
return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("gitsigns").setup({
        signs = {
          add          = { text = "▎" },
          change       = { text = "▎" },
          delete       = { text = "" },
          topdelete    = { text = "" },
          changedelete = { text = "▎" },
        },
        on_attach = function(bufnr)
          local gs   = package.loaded.gitsigns
          local opts = { buffer = bufnr, silent = true }

          -- Navegar entre hunks
          vim.keymap.set("n", "]c", function()
            if vim.wo.diff then return "]c" end
            vim.schedule(gs.next_hunk)
            return "<Ignore>"
          end, { expr = true, buffer = bufnr })
          vim.keymap.set("n", "[c", function()
            if vim.wo.diff then return "[c" end
            vim.schedule(gs.prev_hunk)
            return "<Ignore>"
          end, { expr = true, buffer = bufnr })

          -- Acciones esenciales
          vim.keymap.set("n", "<leader>hp", gs.preview_hunk,                         opts)
          vim.keymap.set("n", "<leader>hs", gs.stage_hunk,                           opts)
          vim.keymap.set("n", "<leader>hr", gs.reset_hunk,                           opts)
          vim.keymap.set("n", "<leader>hb", function() gs.blame_line({ full = true }) end, opts)
        end,
      })
    end,
  },
}
