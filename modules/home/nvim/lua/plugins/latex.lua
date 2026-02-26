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
        envs        = { enabled = 1 },
        cmd_single  = { enabled = 1 },
        sections    = { enabled = 1 },
        comments    = { enabled = 0 },
        preamble    = { enabled = 1 },
        items       = { enabled = 1 },
      }
    end,
    config = function()
      -- Keymaps (complement vimtex's built-in <localleader>l* mappings)
      local map = function(key, cmd, desc)
        vim.keymap.set("n", key, "<cmd>" .. cmd .. "<CR>",
          { noremap = true, silent = true, desc = "VimTeX: " .. desc })
      end

      -- Compile
      map("<leader>lc", "VimtexCompile",       "toggle compilation")
      map("<leader>ls", "VimtexCompileSS",     "single-shot compile")
      map("<leader>lo", "VimtexCompileOutput", "show compile output")

      -- View
      map("<leader>lv", "VimtexView",          "view PDF (Zathura)")

      -- Clean
      map("<leader>lx", "VimtexClean",         "clean aux files")
      map("<leader>lX", "VimtexClean!",        "full clean")

      -- Errors / info
      map("<leader>le", "VimtexErrors",        "show errors")
      map("<leader>li", "VimtexInfo",          "project info")
      map("<leader>lt", "VimtexTocToggle",     "toggle TOC")
    end,
  },
}
