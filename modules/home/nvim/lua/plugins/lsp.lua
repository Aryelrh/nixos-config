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
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls", "pyright", "rust_analyzer",
          "ts_ls",
        },
      })
    end,
  },

  -- LSP Config (core)
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      -- Common keymaps for LSP
      local keymap = vim.keymap.set
      local opts = { noremap = true, silent = true }

      -- Diagnostic keymaps
      keymap("n", "<leader>e", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
      keymap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
      keymap("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
      keymap("n", "<leader>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)

      -- LSP keymaps for on_attach
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

      -- Setup LSP servers using vim.lsp.config (Neovim 0.11+ API)
      -- Use explicit paths for NixOS compatibility
      local nixos_bin = "/etc/profiles/per-user/aryel/bin"
      
      vim.lsp.config("lua_ls", {
        cmd = { nixos_bin .. "/lua-language-server" },
        on_attach = on_attach,
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
      })

      vim.lsp.config("pyright", {
        cmd = { nixos_bin .. "/pyright-langserver", "--stdio" },
        on_attach = on_attach,
      })
      
      vim.lsp.config("rust_analyzer", {
        cmd = { nixos_bin .. "/rust-analyzer" },
        on_attach = on_attach,
        settings = {
          ["rust-analyzer"] = {
            checkOnSave = {
              command = "clippy",
            },
          },
        },
      })
      
      vim.lsp.config("ts_ls", {
        cmd = { nixos_bin .. "/typescript-language-server", "--stdio" },
        on_attach = on_attach,
        init_options = {
          preferences = {
            quotePreference = "single",
            importModuleSpecifierPreference = "relative",
          },
        },
        settings = {
          javascript = {
            suggest = {
              autoImports = true,
            },
            inlayHints = {
              includeInlayParameterNameHints = "all",
              includeInlayParameterNameHintsWhenArgumentMatchesName = true,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayPropertyDeclarationTypeHints = true,
            },
          },
          typescript = {
            suggest = {
              autoImports = true,
            },
            inlayHints = {
              includeInlayParameterNameHints = "all",
              includeInlayParameterNameHintsWhenArgumentMatchesName = true,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayPropertyDeclarationTypeHints = true,
            },
          },
        },
      })

      -- HTML, CSS, JSON (vscode-langservers-extracted)
      -- These can be used with lspconfig if configured properly
      -- For now, ts_ls handles HTML/JS and basic JSON
      -- Advanced HTML/CSS/JSON support is optional

      -- Enable all configured servers
      for _, server in ipairs({ "lua_ls", "pyright", "rust_analyzer", "ts_ls" }) do
        vim.lsp.enable(server)
      end
      
      -- Setup rust_analyzer with FileType autocmd
      local rust_group = vim.api.nvim_create_augroup("rust_analyzer_setup", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        group = rust_group,
        pattern = "rust",
        callback = function()
          vim.lsp.enable("rust_analyzer")
        end,
      })

      -- Setup jdtls with autocmd (special handling for Java)
      local jdtls_group = vim.api.nvim_create_augroup("jdtls_setup", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        group = jdtls_group,
        pattern = "java",
        callback = function(args)
          local jdtls_cmd = "/etc/profiles/per-user/aryel/bin/jdtls"
          
          if vim.fn.executable(jdtls_cmd) == 1 then
            vim.lsp.config("jdtls", {
              cmd = { jdtls_cmd },
              root_dir = vim.fs.find({ "pom.xml", "build.gradle", ".git" }, { upward = true })[1] or vim.fn.getcwd(),
              on_attach = on_attach,
              single_file_support = true,
            })
            vim.lsp.enable("jdtls")
          else
            vim.notify("jdtls not found at: " .. jdtls_cmd, vim.log.levels.WARN)
          end
        end,
      })

      -- Diagnostic symbols in signcolumn (use vim.diagnostic.config instead of sign_define)
      local signs = { Error = "●", Warn = "●", Hint = "●", Info = "●" }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
      end
      
      vim.diagnostic.config({
        signs = true,
        underline = true,
        virtual_text = true,
        update_in_insert = false,
      })
    end,
  },

  -- Autocompletado (nvim-cmp)
  {
    "hrsh7th/nvim-cmp",
    event = { "BufReadPre", "BufNewFile", "InsertEnter" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "saadparwaiz1/cmp_luasnip",
      "L3MON4D3/LuaSnip",
      "rafamadriz/friendly-snippets",
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
    event = { "BufReadPre", "BufNewFile" },
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

  -- Auto-closing pairs (brackets, quotes, etc)
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({
        check_ts = true,
        ts_config = {
          lua = { "string", "comment" },
          javascript = { "string", "template_string", "comment" },
          python = { "string", "comment" },
        },
      })
      -- Integration with nvim-cmp
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },
}