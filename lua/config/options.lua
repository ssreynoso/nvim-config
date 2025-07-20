vim.opt.number = true -- Show the number of the lines.
vim.opt.relativenumber = true
vim.opt.mouse = "a" -- Allow the use of the mouse (?
vim.opt.showmode = false
vim.opt.ignorecase = true -- When search, ignores uppercases. 'two' -> ['two', 'tWo', 'TWo', ...]
vim.opt.smartcase = true -- When search, use the uppercase if we put it. 'tWo' -> ['tWo']
vim.opt.hlsearch = false -- Disable highlight of the previous search.
vim.opt.wrap = true -- Make the text of long lines always visible.
vim.opt.breakindent = true -- Preserve the identation of virtual lines.
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autochdir = false -- Bugs with telescope - plugin

--- Keep signcolumn on by default
vim.o.signcolumn = "yes"

-- Decrease update time
vim.o.updatetime = 250

-- Decrease mapped sequence wait time
vim.o.timeoutlen = 300

-- Configure how new splits should be opened
vim.o.splitright = true
vim.o.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
--
--  Notice listchars is set using `vim.opt` instead of `vim.o`.
--  It is very similar to `vim.o` but offers an interface for conveniently interacting with tables.
--   See `:help lua-options`
--   and `:help lua-options-guide`
vim.o.list = true
vim.opt.listchars = {
    tab = "» ",
    trail = "·",
    nbsp = "␣",
}

-- Preview substitutions live, as you type!
vim.o.inccommand = "split"

-- Show which line your cursor is on
vim.o.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.o.scrolloff = 10

-- Virtual text
vim.diagnostic.config({ virtual_text = true })

-- Terminal
local terminal_selector = require("modules.terminal_selector")

vim.keymap.set("n", "<leader>tn", function()
    terminal_selector.select_terminal(function(shell)
        vim.cmd("terminal " .. shell)
    end)
end, { desc = "Elegir shell para abrir terminal" })

-- Ctrl+Q para salir del modo terminal
vim.keymap.set("t", "<C-q>", [[<C-\><C-n>]], { noremap = true, desc = "Salir del terminal con Ctrl+Q" })

-- Visual: evitar sobrescribir al hacer p o P
vim.keymap.set("x", "p", '"_dp', { noremap = true, desc = "Pegar después sin sobrescribir" })
vim.keymap.set("x", "P", '"_dP', { noremap = true, desc = "Pegar antes sin sobrescribir" })

-- Duplicate line
vim.keymap.set("n", "<leader>d", "yyp", { desc = "Duplicar línea" })

-- Code folding configuration
vim.opt.foldmethod = "indent" -- Usa indentación para crear folds
vim.opt.foldlevel = 99 -- Abre todos los folds por defecto
vim.opt.foldenable = true -- Habilita folding
