
-- ~/.config/nvim/lua/keymaps/nvim-tree.lua

local M = {}

local last_win = nil

function M.setup()
	-- <Leader>e: toggle foco entre nvim-tree y editor
	vim.keymap.set("n", "<Leader>e", function()
		local view = require("nvim-tree.view")
		if view.is_visible() then
			local tree_win = view.get_winnr()
			local current_win = vim.api.nvim_get_current_win()

			if current_win == tree_win then
				if last_win and vim.api.nvim_win_is_valid(last_win) then
					vim.api.nvim_set_current_win(last_win)
				else
					vim.cmd("wincmd p")
				end
			else
				last_win = current_win
				vim.api.nvim_set_current_win(tree_win)
			end
		else
			vim.cmd("NvimTreeToggle")
		end
	end, { desc = "Focus NvimTree or toggle" })

	-- <Leader>E: cerrar el árbol y volver
	vim.keymap.set("n", "<Leader>E", function()
		local view = require("nvim-tree.view")
		if view.is_visible() then
			vim.cmd("NvimTreeClose")
			if last_win and vim.api.nvim_win_is_valid(last_win) then
				vim.api.nvim_set_current_win(last_win)
				last_win = nil
			end
		end
	end, { desc = "Close NvimTree and return" })

	-- <Leader>pd: modo full explorer
	vim.keymap.set("n", "<Leader>pd", function()
		local view = require("nvim-tree.view")
		last_win = vim.api.nvim_get_current_win()

		if view.is_visible() then
			vim.cmd("NvimTreeClose")
		end

		vim.cmd("NvimTreeOpen")
		vim.cmd("wincmd o")
	end, { desc = "Explorer full screen (like Ex)" })
end

return M
