local M = {}

local state = {
    terminal = { buf = -1, win = -1 },
    note = { buf = -1, win = -1 },
    note_cursor = nil, -- guarda la posición del cursor
}

local function create_floating_window(opts)
    opts = opts or {}
    local width = opts.width or math.floor(vim.o.columns * 0.8)
    local height = opts.height or math.floor(vim.o.lines * 0.8)
    local col = math.floor((vim.o.columns - width) / 2)
    local row = math.floor((vim.o.lines - height) / 2)

    local buf = opts.buf
    if not (buf and vim.api.nvim_buf_is_valid(buf)) then
        buf = vim.api.nvim_create_buf(false, true)
    end

    local win_opts = {
        relative = "editor",
        width = width,
        height = height,
        col = col,
        row = row,
        style = "minimal",
        border = "rounded",
        title = opts.title or "",
        title_pos = "center",
    }

    local win = vim.api.nvim_open_win(buf, true, win_opts)

    vim.api.nvim_set_hl(0, "MyCustomBorder", { fg = "#0E2148", bg = "#000000" })

    vim.api.nvim_win_set_option(
        win,
        "winhighlight",
        table.concat({
            "FloatBorder:MyCustomBorder",
            "Normal:TelescopeNormal",
            "FloatTitle:TelescopeTitle",
        }, ",")
    )

    return { buf = buf, win = win }
end

function M.toggle_terminal()
    local uname = vim.loop.os_uname()
    local is_windows = uname.sysname == "Windows_NT"
    local is_wsl = uname.release:match("Microsoft") ~= nil

    if not vim.api.nvim_win_is_valid(state.terminal.win) then
        state.terminal = create_floating_window({ buf = state.terminal.buf, title = "🖥️ Terminal" })
        if vim.bo[state.terminal.buf].buftype ~= "terminal" then
            if is_windows and not is_wsl then
                vim.cmd("terminal wsl")
            else
                vim.cmd("terminal")
            end
            vim.b.floater_terminal = true
        end
    else
        vim.api.nvim_win_hide(state.terminal.win)
    end
end

function M.toggle_note()
    local note_path = vim.fn.stdpath("data") .. "/.nvim_notepad.md"
    local buf

    -- ⚠️ Buscar el buffer ya abierto por nombre
    for _, b in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_get_name(b) == note_path then
            buf = b
            break
        end
    end

    -- Crear archivo si no existe
    if not buf then
        if vim.fn.filereadable(note_path) == 0 then
            vim.fn.writefile({ "# 📒 Nota rápida", "" }, note_path)
        end
        buf = vim.fn.bufadd(note_path)
        vim.fn.bufload(buf)
    end

    local is_open = vim.api.nvim_win_is_valid(state.note.win)

    if not is_open then
        state.note = create_floating_window({ buf = buf, title = "📒 Notepad" })

        vim.bo[buf].filetype = "markdown"
        vim.bo[buf].swapfile = false
        vim.b[buf].floater_note = true
        vim.wo[state.note.win].number = true
        vim.wo[state.note.win].relativenumber = false

        -- Restaurar posición previa
        if state.note_cursor then
            pcall(vim.api.nvim_win_set_cursor, state.note.win, state.note_cursor)
        end

        vim.api.nvim_create_autocmd("CursorMoved", {
            buffer = buf,
            callback = function()
                if vim.api.nvim_win_is_valid(state.note.win) then
                    state.note_cursor = vim.api.nvim_win_get_cursor(state.note.win)
                end
            end,
            desc = "Guardar posición de cursor de la nota",
        })
    else
        -- Guardar cursor y cerrar
        state.note_cursor = vim.api.nvim_win_get_cursor(state.note.win)

        if vim.bo[state.note.buf].modified then
            vim.cmd("write")
        end

        vim.api.nvim_win_hide(state.note.win)
    end
end

vim.api.nvim_create_user_command("Floaterminal", M.toggle_terminal, {})
vim.api.nvim_create_user_command("Floaternote", M.toggle_note, {})

vim.keymap.set("n", "<leader>t", M.toggle_terminal, { desc = "Toggle terminal" })
vim.keymap.set("n", "<leader>n", M.toggle_note, { desc = "Toggle notepad" })

M.state = state

return M
