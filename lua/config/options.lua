vim.opt.number = true -- Show the number of the lines.
vim.opt.mouse = 'a' -- Allow the use of the mouse (?
vim.opt.showmode = false
vim.opt.ignorecase = true -- When search, ignores uppercases. 'two' -> ['two', 'tWo', 'TWo', ...]
vim.opt.smartcase = true -- When search, use the uppercase if we put it. 'tWo' -> ['tWo']
vim.opt.hlsearch = false -- Disable highlight of the previous search.
vim.opt.wrap = true -- Make the text of long lines always visible.
vim.opt.breakindent = true -- Preserve the identation of virtual lines.
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = false
vim.opt.autochdir = false -- Bugs with telescope - plugin

--- Keep signcolumn on by default
vim.o.signcolumn = 'yes'

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
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.o.inccommand = 'split'

-- Show which line your cursor is on
vim.o.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.o.scrolloff = 10

-- Centered layout?
