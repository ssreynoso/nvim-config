local M = {}

local buffer_history = {}
local last_closed_buffer = nil

local function remove_from_history(bufnr)
    for i = #buffer_history, 1, -1 do
        if buffer_history[i] == bufnr then
            table.remove(buffer_history, i)
            break
        end
    end
end

local function add_to_history(bufnr)
    if not vim.api.nvim_buf_is_valid(bufnr) then
        return
    end
    if vim.bo[bufnr].buftype ~= "" then
        return
    end -- descartar terminales, ayuda, etc.
    if vim.bo[bufnr].filetype == "NvimTree" then
        return
    end

    remove_from_history(bufnr)
    table.insert(buffer_history, bufnr)
end

function M.setup()
    vim.api.nvim_create_autocmd("BufEnter", {
        callback = function(args)
            add_to_history(args.buf)
        end,
    })

    vim.keymap.set("n", "<leader>W", function()
        local current_buf = vim.api.nvim_get_current_buf()
        local bufs = vim.fn.getbufinfo({ buflisted = 1 })

        for _, buf in ipairs(bufs) do
            local bt = vim.bo[buf.bufnr].buftype
            local ft = vim.bo[buf.bufnr].filetype

            if bt ~= "terminal" and ft ~= "NvimTree" and buf.bufnr ~= current_buf then
                remove_from_history(buf.bufnr)
                vim.cmd("bdelete " .. buf.bufnr)
            end
        end

        local bt = vim.bo[current_buf].buftype
        local ft = vim.bo[current_buf].filetype

        if bt ~= "terminal" and ft ~= "NvimTree" then
            remove_from_history(current_buf)
            vim.cmd("bdelete " .. current_buf)
        end

        -- Después de cerrar todos, saltar al último válido
        for i = #buffer_history, 1, -1 do
            local b = buffer_history[i]
            if vim.api.nvim_buf_is_valid(b) then
                vim.api.nvim_set_current_buf(b)
                break
            end
        end
    end, { desc = "Cerrar todos los buffers (menos terminal/NvimTree)" })

    vim.keymap.set("n", "<leader>w", function()
        local current_buf = vim.api.nvim_get_current_buf()
        local current_name = vim.api.nvim_buf_get_name(current_buf)
        if current_name ~= "" then
            last_closed_buffer = current_name
        end

        remove_from_history(current_buf)

        local is_modified = vim.bo[current_buf].modified

        -- Buscar buffer alternativo antes de cerrar
        local fallback_buf = nil
        for i = #buffer_history, 1, -1 do
            local bufnr = buffer_history[i]
            if vim.api.nvim_buf_is_valid(bufnr) and bufnr ~= current_buf then
                fallback_buf = bufnr
                break
            end
        end

        if fallback_buf then
            vim.api.nvim_set_current_buf(fallback_buf)
        end

        -- Guardar si está modificado
        if is_modified then
            vim.api.nvim_buf_call(current_buf, function()
                vim.cmd("write")
            end)
        end

        -- Cerrar buffer actual
        if vim.bo[current_buf].buftype == "terminal" then
            vim.cmd("bdelete! " .. current_buf)
        else
            vim.cmd("bdelete " .. current_buf)
        end

        -- Cerrar floatters si están abiertos
        local ok, floatter = pcall(require, "modules.floatter")
        if ok and floatter.state then
            if floatter.state.note and vim.api.nvim_win_is_valid(floatter.state.note.win) then
                floatter.toggle_note()
            end
            if floatter.state.terminal and vim.api.nvim_win_is_valid(floatter.state.terminal.win) then
                floatter.toggle_terminal()
            end
            if floatter.state.lazygit and vim.api.nvim_win_is_valid(floatter.state.lazygit.win) then
                floatter.toggle_lazygit()
            end
            if floatter.state.help and vim.api.nvim_win_is_valid(floatter.state.help.win) then
                vim.api.nvim_win_close(floatter.state.help.win, true)
                floatter.state.help = nil
            end
        end

        -- Cerrar welcome si está abierto
        local ok2, welcome = pcall(require, "modules.welcome")
        if ok2 and welcome.state and welcome.state.win then
            if vim.api.nvim_win_is_valid(welcome.state.win) then
                vim.api.nvim_win_close(welcome.state.win, true)
                welcome.state.win = nil
            end
            if vim.api.nvim_buf_is_valid(welcome.state.buf) then
                vim.api.nvim_buf_delete(welcome.state.buf, { force = true })
                welcome.state.buf = nil
            end
        end
    end, { desc = "Smart close buffer" })

    -- Reabrir el último archivo cerrado
    vim.keymap.set("n", "<leader>T", function()
        if last_closed_buffer and vim.fn.filereadable(last_closed_buffer) == 1 then
            vim.cmd("edit " .. vim.fn.fnameescape(last_closed_buffer))
        else
            vim.notify("No hay buffer reciente para restaurar", vim.log.levels.WARN)
        end
    end, { desc = "Reabrir último buffer cerrado" })

    -- Navegación entre buffers (sin BufferLine)
    vim.keymap.set("n", "<Tab>", "<cmd>bnext<CR>", { desc = "Next buffer" })
    vim.keymap.set("n", "<S-Tab>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
end

return M
