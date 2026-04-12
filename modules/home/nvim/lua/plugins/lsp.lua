-- lua/plugins/lsp.lua
return {
	-- LSP Config
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local km = vim.keymap.set

			-- Diagnostics
			km("n", "<leader>e", vim.diagnostic.open_float, { noremap = true, silent = true })
			km("n", "[d", vim.diagnostic.goto_prev, { noremap = true, silent = true })
			km("n", "]d", vim.diagnostic.goto_next, { noremap = true, silent = true })

			-- Keymaps for buffer at LSP activation
			local on_attach = function(_, bufnr)
				local opts = { noremap = true, silent = true, buffer = bufnr }
				km("n", "gd", vim.lsp.buf.definition, opts)
				km("n", "gD", vim.lsp.buf.declaration, opts)
				km("n", "gi", vim.lsp.buf.implementation, opts)
				km("n", "gr", vim.lsp.buf.references, opts)
				km("n", "K", vim.lsp.buf.hover, opts)
				km("n", "<leader>rn", vim.lsp.buf.rename, opts)
				km("n", "<leader>ca", vim.lsp.buf.code_action, opts)
				km("n", "<leader>f", function()
					vim.lsp.buf.format({ async = true })
				end, opts)
			end

			-- Lua
			vim.lsp.config("lua_ls", {
				cmd = { vim.fn.exepath("lua-language-server") },
				on_attach = on_attach,
				settings = {
					Lua = {
						runtime = { version = "LuaJIT" },
						diagnostics = { globals = { "vim" } },
						workspace = { library = vim.api.nvim_get_runtime_file("", true), checkThirdParty = false },
					},
				},
			})

			-- Python
			vim.lsp.config("pyright", {
				cmd = { vim.fn.exepath("pyright-langserver"), "--stdio" },
				on_attach = on_attach,
			})

			-- Rust
			vim.lsp.config("rust_analyzer", {
				cmd = { vim.fn.exepath("rust-analyzer") },
				on_attach = on_attach,
				settings = { ["rust-analyzer"] = { checkOnSave = { command = "clippy" } } },
			})

			-- JavaScript / TypeScript
			vim.lsp.config("ts_ls", {
				cmd = { vim.fn.exepath("typescript-language-server"), "--stdio" },
				on_attach = on_attach,
				filetypes = {
					"javascript",
					"javascriptreact",
					"javascript.jsx",
					"typescript",
					"typescriptreact",
					"typescript.tsx",
				},
				init_options = {
					preferences = {
						quotePreference = "single",
						importModuleSpecifierPreference = "relative",
					},
				},
			})

			-- Java
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "java",
				callback = function()
					local jdtls = vim.fn.exepath("jdtls")
					if vim.fn.executable(jdtls) == 1 then
						vim.lsp.config("jdtls", {
							cmd = { jdtls },
							root_dir = vim.fs.find({ "pom.xml", "build.gradle", ".git" }, { upward = true })[1]
								or vim.fn.getcwd(),
							on_attach = on_attach,
						})
						vim.lsp.enable("jdtls")
					end
				end,
			})

			-- SQL
			vim.lsp.config("sqls", {
				cmd = { vim.fn.exepath("sqls") },
				on_attach = on_attach,
				filetypes = { "sql", "mysql" },
			})

			-- Prisma
			vim.lsp.config("prismals", {
				cmd = { vim.fn.exepath("prisma-language-server"), "--stdio" },
				on_attach = on_attach,
				filetypes = { "prisma" },
			})

			for _, server in ipairs({ "lua_ls", "pyright", "rust_analyzer", "ts_ls", "sqls" }) do
				vim.lsp.enable(server)
			end

			vim.diagnostic.config({ signs = true, underline = true, virtual_text = true, update_in_insert = false })
		end,
	},

	-- Autocompletion
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
					["<C-Space>"] = cmp.mapping.complete(),
					["<CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
					["<Tab>"] = cmp.mapping(function(fb)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						else
							fb()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fb)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fb()
						end
					end, { "i", "s" }),
				}),
				sources = cmp.config.sources(
					{ { name = "nvim_lsp" }, { name = "luasnip" } },
					{ { name = "buffer" }, { name = "path" } }
				),
			})
		end,
	},

	-- Auto formatting when save
	{
		"stevearc/conform.nvim",
		event = "BufWritePre",
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
					rust = { "rustfmt" },
					java = { "google-java-format" },
				},
				format_on_save = { timeout_ms = 500, lsp_fallback = true },
			})
		end,
	},

	-- Auto close pairs
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function()
			require("nvim-autopairs").setup({ check_ts = true })
			require("cmp").event:on("confirm_done", require("nvim-autopairs.completion.cmp").on_confirm_done())
		end,
	},
}
