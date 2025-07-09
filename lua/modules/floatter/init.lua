local M = {}

local terminal_selector = require("modules.terminal_selector")

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

function M.toggle_lazygit()
    local win = state.lazygit and state.lazygit.win
    local buf = state.lazygit and state.lazygit.buf

    local is_win_valid = type(win) == "number" and vim.api.nvim_win_is_valid(win)
    local is_buf_valid = type(buf) == "number" and vim.api.nvim_buf_is_valid(buf)
    local is_terminal = is_buf_valid and vim.bo[buf].buftype == "terminal"

    if not is_win_valid then
        if not is_buf_valid or not is_terminal then
            state.lazygit = create_floating_window({ title = " Lazygit" })

            vim.cmd("terminal lazygit")
            state.lazygit.buf = vim.api.nvim_get_current_buf()
            vim.b.floater_lazygit = true
        else
            state.lazygit = create_floating_window({ title = " Lazygit", buf = buf })
        end
    else
        vim.api.nvim_win_hide(win)
    end
end

function M.toggle_terminal()
    local is_win_valid = vim.api.nvim_win_is_valid(state.terminal.win)
    local is_buf_valid = vim.api.nvim_buf_is_valid(state.terminal.buf)
    local is_terminal = is_buf_valid and vim.bo[state.terminal.buf].buftype == "terminal"

    if not is_win_valid then
        if not is_buf_valid or not is_terminal then
            -- seleccionar shell y crear terminal si no hay ninguna válida
            terminal_selector.select_terminal(function(shell)
                state.terminal = create_floating_window({ title = "🖥️ Terminal" })

                vim.cmd("terminal " .. shell)
                state.terminal.buf = vim.api.nvim_get_current_buf() -- guardar el buffer nuevo
                vim.b.floater_terminal = true
            end)
        else
            -- si el buffer es válido y es una terminal, abrir en nueva ventana flotante
            state.terminal = create_floating_window({ title = "🖥️ Terminal", buf = state.terminal.buf })
        end
    else
        -- si la ventana ya está abierta, simplemente cerrarla
        vim.api.nvim_win_hide(state.terminal.win)
    end
end

function M.toggle_note()
    local cwd = vim.fn.getcwd()
    local doc_dir = cwd .. "/documentation"
    local note_path = doc_dir .. "/notepad.md"
    local buf

    for _, b in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_get_name(b) == note_path then
            buf = b
            break
        end
    end

    if not buf then
        if vim.fn.isdirectory(doc_dir) == 0 then
            vim.fn.mkdir(doc_dir, "p")
        end
        
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
        vim.wo[state.note.win].relativenumber = true

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
        state.note_cursor = vim.api.nvim_win_get_cursor(state.note.win)

        if vim.bo[state.note.buf].modified then
            vim.cmd("write")
        end

        vim.api.nvim_win_hide(state.note.win)
    end
end

M.create_floating_window = create_floating_window

M.state = state

return M
