return {
	'nvim-telescope/telescope.nvim',
	tag = '0.1.8',
	dependencies = {
		'nvim-lua/plenary.nvim',
		'nvim-tree/nvim-web-devicons',
	},
	config = function()
		local telescope = require('telescope')
		local builtin = require('telescope.builtin')

		telescope.setup({
			defaults = {
				find_command = {
					"fd",
					"--type", "f",
					"--strip-cwd-prefix",
					"--hidden",
					"--exclude", ".git",
					"--exclude", "node_modules"
				},
				layout_strategy = "horizontal",
				sorting_strategy = "ascending",
				winblend = 10,
				layout_config = {
					horizontal = { width = 0.9 },
					vertical = { width = 0.5 },
				},
			},
		})

		-- Keymaps
		vim.keymap.set('n', '<C-p>', builtin.find_files, { desc = '[P]roject find files (con fd)' })
		vim.keymap.set('n', '<leader>f', builtin.live_grep, { desc = '[F]ind text with grep' })
		vim.keymap.set('n', '<leader>h', builtin.help_tags, { desc = '[H]elp' })
		vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
	end,
}
