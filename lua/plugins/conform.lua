
return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" }, -- formatea antes de guardar
	config = function()
		require("conform").setup({
			format_on_save = {
				lsp_fallback = true, -- si no hay formatter externo, usa LSP
				timeout_ms = 500,
			},
			formatters_by_ft = {
				-- cada filetype tiene su(s) herramienta(s)
				lua = { "stylua" },
				python = { "black" },
				javascript = { "prettier" },
				typescript = { "prettier" },
				javascriptreact = { "prettier" },
				typescriptreact = { "prettier" },
				html = { "prettier" },
				css = { "prettier" },
				json = { "prettier" },
				yaml = { "prettier" },
				markdown = { "prettier" },
				sh = { "shfmt" },
			},
		})
	end,
}
