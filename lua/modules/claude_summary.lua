local M = {}

local floatter = require("modules.floatter")

local state = {
    summaries = {}, -- Map: filepath -> { buf = number, content = string }
    current_window = -1, -- Ventana flotante actual
    current_file = nil,
}

local valid_filetypes = {
    "lua",
    "javascript",
    "typescript",
    "python",
    "go",
    "rust",
    "java",
    "c",
    "cpp",
    "markdown",
    "text",
    "json",
    "yaml",
    "toml",
    "vim",
    "sh",
    "bash",
    "zsh",
}

local function is_valid_filetype(ft)
    for _, valid_ft in ipairs(valid_filetypes) do
        if ft == valid_ft then
            return true
        end
    end
    return false
end

local function should_ignore_buffer()
    local buftype = vim.bo.buftype
    local filetype = vim.bo.filetype
    local filename = vim.fn.expand("%:t")
    local filepath = vim.fn.expand("%:p")

    if buftype ~= "" then
        return true
    end

    if filetype == "NvimTree" or filetype == "help" or filetype == "qf" then
        return true
    end

    if filepath:match("NvimTree") or filename == "" then
        return true
    end

    return not is_valid_filetype(filetype)
end

local function get_file_content()
    local lines = vim.api.nvim_buf_get_lines(0, 0, 200, false)
    local content = table.concat(lines, "\n")

    if #content > 8000 then
        content = content:sub(1, 8000) .. "\n\n[... contenido truncado ...]"
    end

    return content
end

local function generate_summary(content, callback)
    local prompt = [[
Resumí brevemente este archivo de código en español.
Quiero un resumen conciso y claro, sin detalles técnicos innecesarios.
Explicá qué hace y su propósito principal en un máximo de 6 líneas:

]] .. content

    -- Llamada directa: argv = { "claude", "--print", prompt }
    vim.fn.jobstart({ "claude", "--print", prompt }, {
        pty = true, -- finge un TTY, no pide ENTER
        stdout_buffered = true,
        on_stdout = function(_, data)
            if data and #data > 0 then
                local raw = table.concat(data, "\n")

                -- 1. quitamos retornos de carro (^\r y ^M)
                raw = raw:gsub("\r", "")

                -- 2. eliminamos secuencias ANSI (ej: [?25h)
                -- Eliminamos todas las secuencias ANSI de forma más completa
                raw = raw:gsub("\27%[[%d;?]*[a-zA-Z]", "")  -- Secuencias básicas como [?25h
                raw = raw:gsub("\27%]%d*;.*\7", "")         -- Secuencias OSC terminadas en BEL
                raw = raw:gsub("\27%(.", "")                -- Secuencias de charset
                raw = raw:gsub("\27%)", "")

                -- 3. recortamos espacios al inicio / fin
                local summary = raw:gsub("^%s+", ""):gsub("%s+$", "")
                if summary ~= "" then
                    callback(summary)
                end
            end
        end,
        on_stderr = function(_, data)
            if data and #data > 0 then
                callback("Error generando resumen: " .. table.concat(data, "\n"))
            end
        end,
        on_exit = function(_, code)
            if code ~= 0 then
                callback("Error: Claude Code falló con código " .. code)
            end
        end,
    })
end

local function create_summary_window(filepath, summary)
    -- Cerrar la ventana anterior, si existe
    if vim.api.nvim_win_is_valid(state.current_window) then
        vim.api.nvim_win_close(state.current_window, true)
    end

    local buf
    local existing = state.summaries[filepath]
    
    if existing and vim.api.nvim_buf_is_valid(existing.buf) then
        -- Reutilizar buffer existente
        buf = existing.buf
    else
        -- Crear nuevo buffer
        buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(summary, "\n"))
        
        -- Guardar en el estado
        state.summaries[filepath] = {
            buf = buf,
            content = summary
        }
        
        -- Opciones de buffer
        vim.bo[buf].modifiable = false
        vim.bo[buf].readonly = true
        vim.bo[buf].filetype = "markdown"
    end

    -- Crear ventana flotante
    local window_info = floatter.create_floating_window({
        buf = buf,
        title = " 🤖 Claude Summary ",
    })
    
    state.current_window = window_info.win

    -- Opciones de ventana
    vim.wo[state.current_window].number = true
    vim.wo[state.current_window].relativenumber = false

    -- Cerrar la ventana al salir del buffer original
    vim.api.nvim_create_autocmd({ "BufLeave", "WinLeave" }, {
        buffer = vim.api.nvim_get_current_buf(),
        once = true,
        callback = function()
            if vim.api.nvim_win_is_valid(state.current_window) then
                vim.defer_fn(function()
                    if vim.api.nvim_win_is_valid(state.current_window) then
                        vim.api.nvim_win_close(state.current_window, true)
                    end
                end, 100)
            end
        end,
    })
end

local function open_loading_window()
    if vim.api.nvim_win_is_valid(state.current_window) then
        vim.api.nvim_win_close(state.current_window, true)
    end

    -- Buffer con placeholder
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "⏳ Cargando resumen..." })

    -- Crear ventana flotante
    local window_info = floatter.create_floating_window({
        buf = buf,
        title = " 🤖 Claude Summary ",
    })
    
    state.current_window = window_info.win

    vim.bo[buf].modifiable = false
    vim.wo[state.current_window].number = false
    vim.wo[state.current_window].relativenumber = false
end

function M.show_summary()
    if should_ignore_buffer() then
        return
    end

    local current_file = vim.fn.expand("%:p")
    state.current_file = current_file
    
    -- Si ya existe un buffer para este archivo, mostrarlo directamente
    local existing = state.summaries[current_file]
    if existing and vim.api.nvim_buf_is_valid(existing.buf) then
        create_summary_window(current_file, existing.content)
        return
    end

    -- Si no existe, generar nuevo resumen
    local content = get_file_content()
    if content == "" then
        return
    end

    open_loading_window()
    generate_summary(content, function(summary)
        vim.schedule(function()
            create_summary_window(current_file, summary)
        end)
    end)
end

function M.refresh_summary()
    if should_ignore_buffer() then
        vim.notify("No se puede generar resumen para este tipo de archivo", vim.log.levels.WARN)
        return
    end

    local current_file = vim.fn.expand("%:p")
    
    -- Eliminar buffer existente del cache
    local existing = state.summaries[current_file]
    if existing and vim.api.nvim_buf_is_valid(existing.buf) then
        vim.api.nvim_buf_delete(existing.buf, { force = true })
    end
    state.summaries[current_file] = nil

    if vim.api.nvim_win_is_valid(state.current_window) then
        vim.api.nvim_win_close(state.current_window, true)
    end

    M.show_summary()
end

function M.close_summary()
    if vim.api.nvim_win_is_valid(state.current_window) then
        vim.api.nvim_win_close(state.current_window, true)
    end
end

function M.is_open()
    return vim.api.nvim_win_is_valid(state.current_window)
end

function M.toggle_summary()
    if M.is_open() then
        M.close_summary()
    else
        M.show_summary()
    end
end

function M.setup()
    --[[ vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "*",
        callback = function()
            vim.defer_fn(function()
                M.show_summary()
            end, 100)
        end,
        desc = "Auto show Claude summary on buffer enter",
    }) ]]

    vim.api.nvim_create_user_command("ClaudeSummaryRefresh", M.refresh_summary, {
        desc = "Refresh Claude AI summary for current file",
    })

    vim.api.nvim_create_user_command("ClaudeSummaryClose", M.close_summary, {
        desc = "Close Claude AI summary window",
    })
end

return M
