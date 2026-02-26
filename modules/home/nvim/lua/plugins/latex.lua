-- lua/plugins/latex.lua
return {
  {
    "lervag/vimtex",
    lazy = false, -- vimtex needs to load early to detect filetypes correctly
    init = function()
      -- PDF viewer: Zathura with forward/inverse search support
      vim.g.vimtex_view_method = "zathura"

      -- Compiler: latexmk (default, works well with zathura)
      vim.g.vimtex_compiler_method = "latexmk"
      vim.g.vimtex_compiler_latexmk = {
        aux_dir = ".aux",
        out_dir = "",
        callback = 1,
        continuous = 1,
        executable = "latexmk",
        hooks = {},
        options = {
          "-verbose",
          "-file-line-error",
          "-synctex=1", -- required for forward/inverse search with Zathura
          "-interaction=nonstopmode",
        },
      }

      -- General settings
      vim.g.vimtex_quickfix_mode = 0       -- don't open quickfix automatically
      vim.g.vimtex_mappings_enabled = 1    -- enable default vimtex mappings
      vim.g.vimtex_indent_enabled = 1      -- enable LaTeX indentation
      vim.g.vimtex_syntax_enabled = 1      -- enable syntax highlighting

      -- Fold settings
      vim.g.vimtex_fold_enabled = 1
      vim.g.vimtex_fold_types = {
        envs = { enabled = 1 },
        env_options = {},
        cmd_single = { enabled = 1 },
        sections = { enabled = 1 },
        markers = {},
        comments = { enabled = 0 },
        preamble = { enabled = 1 },
        items = { enabled = 1 },
      }
    end,
    config = function()
      -- Keymaps (complement vimtex's built-in <localleader>l* mappings)
      local km = vim.keymap.set
      local opts = { noremap = true, silent = true }

      -- Compile
      km("n", "<leader>lc", "<cmd>VimtexCompile<CR>",        vim.tbl_extend("force", opts, { desc = "VimTeX: toggle compilation" }))
      km("n", "<leader>ls", "<cmd>VimtexCompileSS<CR>",      vim.tbl_extend("force", opts, { desc = "VimTeX: single-shot compile" }))
      km("n", "<leader>lo", "<cmd>VimtexCompileOutput<CR>",  vim.tbl_extend("force", opts, { desc = "VimTeX: show compile output" }))

      -- View
      km("n", "<leader>lv", "<cmd>VimtexView<CR>",           vim.tbl_extend("force", opts, { desc = "VimTeX: view PDF (Zathura)" }))

      -- Clean
      km("n", "<leader>lx", "<cmd>VimtexClean<CR>",          vim.tbl_extend("force", opts, { desc = "VimTeX: clean aux files" }))
      km("n", "<leader>lX", "<cmd>VimtexClean!<CR>",         vim.tbl_extend("force", opts, { desc = "VimTeX: full clean" }))

      -- Errors / info
      km("n", "<leader>le", "<cmd>VimtexErrors<CR>",         vim.tbl_extend("force", opts, { desc = "VimTeX: show errors" }))
      km("n", "<leader>li", "<cmd>VimtexInfo<CR>",           vim.tbl_extend("force", opts, { desc = "VimTeX: project info" }))
      km("n", "<leader>lt", "<cmd>VimtexTocToggle<CR>",      vim.tbl_extend("force", opts, { desc = "VimTeX: toggle TOC" }))
    end,
  },
}
