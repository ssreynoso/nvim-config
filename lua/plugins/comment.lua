return {
	"numToStr/Comment.nvim",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"JoosepAlviste/nvim-ts-context-commentstring",
	},
	config = function()
		vim.g.skip_ts_context_commentstring_module = true
		require("ts_context_commentstring").setup({}) -- nueva forma recomendada

		local comment = require("Comment")
		local ts_context_commentstring = require("ts_context_commentstring.integrations.comment_nvim")

		comment.setup({
			pre_hook = ts_context_commentstring.create_pre_hook(),
		})

		-- Mapeos para comentar
		-- Modo normal: comenta la línea actual
		vim.keymap.set("n", "<leader>q", "<Plug>(comment_toggle_linewise_current)", { desc = "Comentar línea actual" })
		vim.keymap.set("n", "<C-q>", "<Plug>(comment_toggle_linewise_current)", { desc = "Comentar línea actual" })

		-- Modo visual: comenta la selección
		vim.keymap.set("v", "<C-q>", "<Plug>(comment_toggle_linewise_visual)", { desc = "Comentar selección" })
		vim.keymap.set("v", "<leader>q", "<Plug>(comment_toggle_linewise_visual)", { desc = "Comentar selección" })
	end,
}
