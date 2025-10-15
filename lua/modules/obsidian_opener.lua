local M = {}

-- URL encode helper function
local function url_encode(str)
    if str then
        str = string.gsub(str, "\n", "\r\n")
        str = string.gsub(str, "([^%w _%%%-%.~])", function(c)
            return string.format("%%%02X", string.byte(c))
        end)
        str = string.gsub(str, " ", "%%20")
    end
    return str
end

-- Get project root name (from git root or cwd)
local function get_project_name()
    local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]

    if vim.v.shell_error == 0 and git_root then
        return vim.fn.fnamemodify(git_root, ":t")
    else
        -- Fallback to current working directory name
        return vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
    end
end

function M.open_in_obsidian()
    -- Check if running on Linux
    if vim.fn.has("linux") ~= 1 then
        vim.notify("Funcionalidad no disponible: solo compatible con Linux", vim.log.levels.WARN)
        return
    end

    local filepath = vim.fn.expand("%:p")
    local filetype = vim.bo.filetype

    -- Verify it's a markdown file
    if filetype ~= "markdown" then
        vim.notify("Este archivo no es Markdown", vim.log.levels.WARN)
        return
    end

    -- Get project name
    local project_name = get_project_name()
    local filename = vim.fn.expand("%:t")
    local prefixed_filename = project_name .. "-" .. filename

    -- Obsidian vault path
    local vault_dir = vim.fn.expand("~/obsidian/markdown/.md")
    local target_path = vault_dir .. "/" .. prefixed_filename

    -- Create vault directory if it doesn't exist
    if vim.fn.isdirectory(vault_dir) == 0 then
        local ok = vim.fn.mkdir(vault_dir, "p")
        if ok == 0 then
            vim.notify("No se pudo crear el directorio del vault: " .. vault_dir, vim.log.levels.ERROR)
            return
        end
        vim.notify("Vault creado: " .. vault_dir, vim.log.levels.INFO)
    end

    -- Copy file if it doesn't exist in vault
    if vim.fn.filereadable(target_path) == 0 then
        local copy_cmd = string.format("cp %s %s", vim.fn.shellescape(filepath), vim.fn.shellescape(target_path))
        local result = vim.fn.system(copy_cmd)

        if vim.v.shell_error ~= 0 then
            vim.notify("Error al copiar archivo: " .. result, vim.log.levels.ERROR)
            return
        end

        vim.notify("Archivo copiado: " .. prefixed_filename, vim.log.levels.INFO)
    end

    -- Build Obsidian URI
    local vault_name = ".md"
    local encoded_filename = url_encode(prefixed_filename)
    local uri = string.format("obsidian://open?vault=%s&file=%s", vault_name, encoded_filename)

    -- Open with xdg-open (Linux)
    vim.fn.jobstart({ "xdg-open", uri }, { detach = true })
    vim.notify("Abriendo en Obsidian: " .. prefixed_filename, vim.log.levels.INFO)
end

return M
