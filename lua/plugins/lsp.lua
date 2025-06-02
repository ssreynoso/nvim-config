return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"stevearc/conform.nvim",
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"hrsh7th/nvim-cmp",
		"L3MON4D3/LuaSnip",
		"saadparwaiz1/cmp_luasnip",
		"j-hui/fidget.nvim",
	},

	config = function()
		require("conform").setup({}) -- Lo vamos a configurar más adelante

		local cmp = require("cmp")
		local cmp_lsp = require("cmp_nvim_lsp")
		local capabilities = vim.tbl_deep_extend(
			"force",
			vim.lsp.protocol.make_client_capabilities(),
			cmp_lsp.default_capabilities()
		)

		require("fidget").setup({})
		require("mason").setup()

		require("mason-lspconfig").setup({
			ensure_installed = {
				-- LSPs
				"ts_ls",
				"html",
				"cssls",
				"jsonls",
				"tailwindcss",
				"emmet_ls",
				"lua_ls",
				"rust_analyzer",
				"pyright",
				"eslint",
			},

			handlers = {
				function(server_name)
					require("lspconfig")[server_name].setup {
						capabilities = capabilities,
					}
				end,

				["ts_ls"] = function()
					require("lspconfig").tsserver.setup {
						capabilities = capabilities,
						root_dir = require("lspconfig.util").root_pattern("tsconfig.json", "package.json", ".git"),
					}
				end,

				["lua_ls"] = function()
					require("lspconfig").lua_ls.setup {
						capabilities = capabilities,
						settings = {
							Lua = {
								format = {
									enable = true,
									defaultConfig = {
										indent_style = "space",
										indent_size = "2",
									},
								},
							},
						},
					}
				end,
			}
		})

		-- Autocompletado
		local cmp_select = { behavior = cmp.SelectBehavior.Select }
		cmp.setup({
			snippet = {
				expand = function(args)
					require("luasnip").lsp_expand(args.body)
				end,
			},
			mapping = cmp.mapping.preset.insert({
				['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
				['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
				['<C-y>'] = cmp.mapping.confirm({ select = true }),
				["<C-Space>"] = cmp.mapping.complete(),
			}),
			sources = cmp.config.sources({
				{ name = 'nvim_lsp' },
				{ name = 'luasnip' },
			}, {
					{ name = 'buffer' },
				}),
		})

		-- Diagnóstico flotante prolijo
		vim.diagnostic.config({
			float = {
				focusable = false,
				style = "minimal",
				border = "rounded",
				source = "always",
				header = "",
				prefix = "",
			},
		})
	end,
}
