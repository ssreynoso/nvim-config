-- ~/.config/nvim/lua/plugins/telescope.lua
return {
	'nvim-telescope/telescope.nvim',
	tag = '0.1.8',
	dependencies = { 'nvim-lua/plenary.nvim' },
	config = function()
		-- Config general de Telescope
		require('telescope').setup({
			defaults = {
				layout_config = {
					horizontal = { width = 0.9 },
					vertical = { width = 0.5 }
				},
				sorting_strategy = "ascending",
				layout_strategy = "horizontal",
				winblend = 10,
				file_ignore_patterns = { "node_modules", ".git/" },
			}
		})

		-- Keymaps
		local builtin = require("telescope.builtin")
		vim.keymap.set('n', '<C-p>', function()
			local utils = require("telescope.utils")
			local is_git_repo = utils.get_os_command_output({ "git", "rev-parse", "--is-inside-work-tree" })[1] == "true"

			if is_git_repo then
				builtin.git_files()
			else
				builtin.find_files({
					hidden = true,
					file_ignore_patterns = { "%.git/", "node_modules/" },
				})
			end
		end, { desc = '[P]roject [G]it-aware find' })
		vim.keymap.set('n', '<leader>h', builtin.help_tags, { desc = '[S]earch [H]elp' })
		vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
		vim.keymap.set('n', '<leader>f', builtin.live_grep, {})
	end
}

