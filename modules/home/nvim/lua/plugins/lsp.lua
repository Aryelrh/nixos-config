-- lua/plugins/lsp.lua
return {
  -- Mason: Auto plugin manager for servers LSP, linters y formatters
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    config = true,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls", "pyright", "rust_analyzer",
          "clangd", "tsserver", "eslint",
        },
      })
    end,
  },

  -- LSP Config (core)
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")

      -- Keymaps comunes para LSP
      local keymap = vim.keymap.set
      local opts = { noremap = true, silent = true }

      -- Diagnostic keymaps
      keymap("n", "<leader>e", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
      keymap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
      keymap("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
      keymap("n", "<leader>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)

      -- LSP keymaps
      local on_attach = function(client, bufnr)
        opts.buffer = bufnr

        keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
        keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
        keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
        keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
        keymap("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
        keymap("n", "<leader>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
        keymap("n", "<leader>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
        keymap("n", "<leader>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
        keymap("n", "<leader>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
        keymap("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
        keymap("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
        keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
        keymap("n", "<leader>f", "<cmd>lua vim.lsp.buf.format({ async = true })<CR>", opts)
      end

      -- LSP servers setup
      local servers = {
        lua_ls = {
          settings = {
            Lua = {
              runtime = { version = "LuaJIT" },
              diagnostics = { globals = { "vim" } },
              workspace = {
                library = {
                  [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                  [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
                },
              },
            },
          },
        },
        pyright = {},
        rust_analyzer = {},
        clangd = {},
        tsserver = {},
        eslint = {
          settings = {
            -- eslint.format.enable = true,
          },
        },
      }

      for name, config in pairs(servers) do
        lspconfig[name].setup({
          on_attach = on_attach,
          settings = config.settings,
        })
      end

      -- Diagnostic symbols en signcolumn
      for name, icon in pairs({
        Error = " ",
        Warn = " ",
        Hint = " ",
        Info = " ",
      }) do
        vim.fn.sign_define("DiagnosticSign" .. name, { text = icon, texthl = "DiagnosticSign" .. name, numhl = "" })
      end
    end,
  },

  -- Autocompletado (nvim-cmp)
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "saadparwaiz1/cmp_luasnip",
      "L3MON4D3/LuaSnip",
      "rafamadriz/friendly-snippets", -- Snippets útiles
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
        }, {
          { name = "buffer" },
          { name = "path" },
        }),
      })

      -- Visual mode snippets configuration
      cmp.setup.filetype("gitcommit", {
        sources = cmp.config.sources({
          { name = "cmp_git" },
        }, {
          { name = "buffer" },
        }),
      })

      -- LSP global configuration
      cmp.setup.cmdline("/", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })

      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          { name = "cmdline" },
        }),
      })
    end,
  },

  -- Auto formatting with conform.nvim
  {
    "stevearc/conform.nvim",
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          lua = { "stylua" },
          python = { "isort", "black" },
          javascript = { "prettier" },
          typescript = { "prettier" },
          css = { "prettier" },
          html = { "prettier" },
          json = { "prettier" },
          yaml = { "prettier" },
          markdown = { "prettier" },
          rust = { "rustfmt" },
          cpp = { "clang-format" },
          java = { "google-java-format" },
        },
        format_on_save = {
          timeout_ms = 500,
          lsp_fallback = true,
        },
      })

      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*",
        callback = function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
      })
    end,
  },
}
