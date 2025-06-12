local M = {}

function M.select_with_callback(cb)
    local persistence = require("persistence")
    local sessions = persistence.list()
    if not sessions or vim.tbl_isempty(sessions) then
        vim.notify("No hay sesiones guardadas.", vim.log.levels.INFO)
        return
    end

    vim.ui.select(sessions, {
        prompt = "Seleccionar sesión:",
        format_item = function(item)
            local path = type(item) == "table" and item.dir or item
            return vim.fn.fnamemodify(path, ":t")
        end,
    }, function(choice)
        if choice then
            local path = type(choice) == "table" and choice.dir or choice
            persistence.load({ dir = path })
            if cb then
                cb(choice)
            end
        end
    end)
end

return M
