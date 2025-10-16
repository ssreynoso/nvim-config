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

-- Get relative path from project root
local function get_relative_path()
    local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
    local project_root

    if vim.v.shell_error == 0 and git_root then
        project_root = git_root
    else
        -- Fallback to current working directory
        project_root = vim.fn.getcwd()
    end

    local filepath = vim.fn.expand("%:p")
    local relative_path = vim.fn.fnamemodify(filepath, ":~:.")

    -- If we got an absolute path, try to make it relative to project root
    if vim.startswith(relative_path, "/") or vim.startswith(relative_path, "~") then
        -- Remove project root from absolute path
        relative_path = filepath:gsub("^" .. vim.pesc(project_root) .. "/", "")
    end

    return relative_path
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

    -- Get project name and relative path
    local project_name = get_project_name()
    local relative_path = get_relative_path()

    -- Obsidian vault path
    local vault_dir = vim.fn.expand("~/obsidian/markdown/.md")
    local project_dir = vault_dir .. "/" .. project_name
    local target_path = project_dir .. "/" .. relative_path

    -- Create vault directory if it doesn't exist
    if vim.fn.isdirectory(vault_dir) == 0 then
        local ok = vim.fn.mkdir(vault_dir, "p")
        if ok == 0 then
            vim.notify("No se pudo crear el directorio del vault: " .. vault_dir, vim.log.levels.ERROR)
            return
        end
        vim.notify("Vault creado: " .. vault_dir, vim.log.levels.INFO)
    end

    -- Create project directory if it doesn't exist
    if vim.fn.isdirectory(project_dir) == 0 then
        local ok = vim.fn.mkdir(project_dir, "p")
        if ok == 0 then
            vim.notify("No se pudo crear el directorio del proyecto: " .. project_dir, vim.log.levels.ERROR)
            return
        end
    end

    -- Create subdirectories if needed (for nested files)
    local target_dir = vim.fn.fnamemodify(target_path, ":h")
    if vim.fn.isdirectory(target_dir) == 0 then
        local ok = vim.fn.mkdir(target_dir, "p")
        if ok == 0 then
            vim.notify("No se pudo crear los subdirectorios: " .. target_dir, vim.log.levels.ERROR)
            return
        end
    end

    -- Create symlink if it doesn't exist in vault
    if vim.fn.filereadable(target_path) == 0 then
        local symlink_cmd = string.format("ln -s %s %s", vim.fn.shellescape(filepath), vim.fn.shellescape(target_path))
        local result = vim.fn.system(symlink_cmd)

        if vim.v.shell_error ~= 0 then
            vim.notify("Error al crear symlink: " .. result, vim.log.levels.ERROR)
            return
        end

        vim.notify("Symlink creado: " .. project_name .. "/" .. relative_path, vim.log.levels.INFO)
    end

    -- Build Obsidian URI with project folder and relative path
    local vault_name = ".md"
    local obsidian_path = project_name .. "/" .. relative_path
    local encoded_path = url_encode(obsidian_path)
    local uri = string.format("obsidian://open?vault=%s&file=%s", vault_name, encoded_path)

    -- Open with xdg-open (Linux)
    vim.fn.jobstart({ "xdg-open", uri }, { detach = true })
    vim.notify("Abriendo en Obsidian: " .. obsidian_path, vim.log.levels.INFO)
end

return M
