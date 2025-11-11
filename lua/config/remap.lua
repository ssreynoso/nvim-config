vim.g.mapleader = " " -- Use space as <leader>
vim.g.maplocalleader = "\\" -- Use space as <leader>

-- Escape to normal mode
vim.keymap.set("i", "jk", "<Esc>", { desc = "Exit insert mode" })
vim.keymap.set("v", "jk", "<Esc>", { desc = "Exit visualization mode" })
vim.keymap.set("t", "jk", [[<C-\><C-n>]], { noremap = true, desc = "Exit terminal mode" })

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

-- Remap ctrl d &ctrl
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Searchs
vim.keymap.set("n", "n", function()
    local word = vim.fn.expand("<cword>")
    vim.fn.search("\\V\\<" .. word .. "\\>", "W")
    vim.cmd("normal! zz")
end, { desc = "Search current word forward and center" })

vim.keymap.set("n", "N", function()
    local word = vim.fn.expand("<cword>")
    vim.fn.search("\\V\\<" .. word .. "\\>", "bW")
    vim.cmd("normal! zz")
end, { desc = "Search current word backward and center" })

-- Move files
vim.keymap.set("n", "<leader>mv", function()
    require("modules.move_files").pick_files()
end, { desc = "Mover archivos con Telescope" })

-- Pick and open files
vim.keymap.set("n", "<C-p>", function()
    require("modules.pick_files").pick_and_open_files()
end, { desc = "Seleccionar y abrir múltiples archivos" })

-- Save all and quit Neovim
vim.keymap.set("n", "<leader>qq", ":wqa<CR>", { desc = "Guardar y salir" })

-- Toggle summary with Claude
vim.keymap.set("n", "<leader>su", function()
    require("modules.claude_summary").toggle_summary()
end, { desc = "Toggle Claude Summary" })

-- Open markdown file in Obsidian
vim.keymap.set("n", "<leader>md", function()
    require("modules.obsidian_opener").open_in_obsidian()
end, { desc = "Abrir archivo Markdown en Obsidian" })

-- Open file explorer in current file's directory
vim.keymap.set("n", "<leader>ex", function()
    local file_dir = vim.fn.expand("%:p:h")
    if file_dir and file_dir ~= "" then
        vim.fn.jobstart({ "xdg-open", file_dir }, { detach = true })
        vim.notify("Abriendo explorador en: " .. file_dir, vim.log.levels.INFO)
    else
        vim.notify("No hay archivo actual", vim.log.levels.WARN)
    end
end, { desc = "Abrir explorador de archivos en la carpeta actual" })

-- Navigate between windows with wrapping (cyclic behavior)
vim.keymap.set("n", "<C-w>h", function()
    local current_win = vim.fn.winnr()
    vim.cmd("wincmd h")
    -- Si no nos movimos (no hay ventana a la izquierda), ir al extremo derecho
    if vim.fn.winnr() == current_win then
        vim.cmd("wincmd l")
        -- Seguir yendo a la derecha hasta llegar al extremo
        while vim.fn.winnr() ~= current_win do
            current_win = vim.fn.winnr()
            vim.cmd("wincmd l")
        end
    end
end, { desc = "Ir a ventana izquierda (cíclico)" })

vim.keymap.set("n", "<C-w>l", function()
    local current_win = vim.fn.winnr()
    vim.cmd("wincmd l")
    -- Si no nos movimos (no hay ventana a la derecha), ir al extremo izquierdo
    if vim.fn.winnr() == current_win then
        vim.cmd("wincmd h")
        -- Seguir yendo a la izquierda hasta llegar al extremo
        while vim.fn.winnr() ~= current_win do
            current_win = vim.fn.winnr()
            vim.cmd("wincmd h")
        end
    end
end, { desc = "Ir a ventana derecha (cíclico)" })
