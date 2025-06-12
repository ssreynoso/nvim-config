local M = {}

function M.select_with_callback(cb)
    local persistence = require("persistence")
    local sessions = persistence.list()

    local function notify(msg)
        vim.notify(msg, vim.log.levels.INFO, { timeout = 8000 })
    end

    if not sessions or vim.tbl_isempty(sessions) then
        notify("❌ No hay sesiones guardadas.")
        return
    end

    local cwd = vim.fn.getcwd()
    local encoded_name = cwd:gsub(":", ""):gsub("[\\/]", "%%") .. ".vim"

    local filtered = vim.tbl_filter(function(path)
        return vim.fn.fnamemodify(path, ":t") == encoded_name
    end, sessions)

    if vim.tbl_isempty(filtered) then
        notify("⚠️ No hay sesiones para este proyecto.")
        return
    end

    -- 🚀 Si solo hay una sesión, la cargamos directo
    if #filtered == 1 then
        local session = filtered[1]
        notify("📂 Cargando sesión automáticamente: " .. session)
        persistence.load({ dir = session })
        if cb then
            cb(session)
        end
        return
    end

    -- 🔘 Si hay más de una, mostramos selección
    vim.ui.select(filtered, {
        prompt = "Seleccionar sesión:",
        format_item = function(item)
            return vim.fn.fnamemodify(item, ":t")
        end,
    }, function(choice)
        if choice then
            notify("📂 Cargando sesión: " .. choice)
            persistence.load({ dir = choice })
            if cb then
                cb(choice)
            end
        end
    end)
end

return M
