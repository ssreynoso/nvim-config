vim.g.mapleader = " " -- Use space as <leader>
vim.g.maplocalleader = "\\" -- Use space as <leader>

-- vim.keymap.set("n", "<leader>pd", vim.cmd.Ex) -- Disabled because of nvim-tree
vim.keymap.set("n", "<leader>w", "<cmd>write<cr>", { desc = "Save" })

-- Clipboard
-- vim.keymap.set({'n', 'x'}, 'gy', '"+y') -- Copy to clipboard
-- vim.keymap.set({'n', 'x'}, 'gp', '"+p') -- Paste from clipboard

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
	vim.o.clipboard = "unnamedplus"
end)

-- Delete without changing the registers
vim.keymap.set({ "n", "x" }, "x", '"_x')
vim.keymap.set({ "n", "x" }, "X", '"_d')

-- Select all text in current buffer
vim.keymap.set("n", "<leader>a", ":keepjumps normal! ggVG<cr>")

-- Mover línea abajo
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==", { desc = "Mover línea abajo", silent = true })
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Mover selección abajo", silent = true })

-- Mover línea arriba
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==", { desc = "Mover línea arriba", silent = true })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Mover selección arriba", silent = true })

-- Guardar
vim.keymap.set("n", "<leader>s", "<cmd>w<cr>", { desc = "Guardar archivo" })
