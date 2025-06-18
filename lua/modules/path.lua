local M = {}

-- Determina si un path contiene caracteres que necesitan escape en :edit
---@param path string
---@return boolean
local function needs_escaping(path)
    return path:find("[%(%)]") or path:find(" ") or path:find('"') -- or path:find("\\")
end

--- Escapa caracteres especiales para rutas en comandos de Vim como :edit
---@param path string
---@return string
function M.escape_path(path)
    return path:gsub("\\", "\\\\"):gsub("%(", "\\("):gsub("%)", "\\)"):gsub(" ", "\\ "):gsub('"', '\\"')
end

--- Devuelve el path original o escapado según necesidad
---@param path string
---@return string
function M.smart_escape_path(path)
    if needs_escaping(path) then
        return M.escape_path(path)
    else
        return path
    end
end

return M
