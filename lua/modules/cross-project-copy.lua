-- ~/.config/nvim/lua/modules/cross-project-copy.lua

local M = {}

-- Configuration
local TEMP_DIR = vim.fn.expand("~/.config/nvim-temp")
local TEMP_FILE = TEMP_DIR .. "/copy.txt"

-- Ensure temp directory exists
local function ensure_temp_dir()
    vim.fn.mkdir(TEMP_DIR, "p")
end

-- Copy file/folder path to temporary file for cross-project use
function M.copy_for_cross_project(node)
    if not node then 
        vim.notify("❌ No node selected", vim.log.levels.ERROR)
        return 
    end

    ensure_temp_dir()
    
    local file = io.open(TEMP_FILE, "w")
    if file then
        file:write(node.absolute_path)
        file:close()
        vim.notify("📋 Copied for cross-project use: " .. node.name, vim.log.levels.INFO)
    else
        vim.notify("❌ Error saving temporary file", vim.log.levels.ERROR)
    end
end

-- Paste file/folder from temporary file
function M.paste_from_cross_project(dest_node, api)
    -- Check if temp file exists
    if vim.fn.filereadable(TEMP_FILE) == 0 then
        vim.notify("📋 No files copied for cross-project use", vim.log.levels.WARN)
        return
    end

    -- Read source path from temp file
    local file = io.open(TEMP_FILE, "r")
    if not file then
        vim.notify("❌ Error reading temporary file", vim.log.levels.ERROR)
        return
    end
    
    local source_path = file:read("*line")
    file:close()

    if not source_path or source_path == "" then
        vim.notify("❌ Empty temporary file", vim.log.levels.ERROR)
        return
    end

    -- Verify source file/folder still exists
    if vim.fn.isdirectory(source_path) == 0 and vim.fn.filereadable(source_path) == 0 then
        vim.notify("❌ Source file no longer exists: " .. source_path, vim.log.levels.ERROR)
        return
    end

    -- Determine destination directory
    local dest_dir
    if dest_node then
        if dest_node.type == "directory" then
            dest_dir = dest_node.absolute_path
        else
            dest_dir = vim.fn.fnamemodify(dest_node.absolute_path, ":h")
        end
    else
        -- Fallback: use current tree root or cursor position
        local current_node = api.tree.get_node_at_cursor()
        if current_node then
            dest_dir = current_node.absolute_path
        else
            vim.notify("❌ Cannot determine destination directory", vim.log.levels.ERROR)
            return
        end
    end

    -- Execute copy command
    local source_name = vim.fn.fnamemodify(source_path, ":t")
    local cmd = string.format('cp -r "%s" "%s"', source_path, dest_dir)
    local result = vim.fn.system(cmd)
    
    if vim.v.shell_error == 0 then
        vim.notify("✅ Successfully pasted: " .. source_name .. " → " .. dest_dir, vim.log.levels.INFO)
        -- Refresh nvim-tree
        if api and api.tree and api.tree.reload then
            api.tree.reload()
        end
        -- Clean up temp file
        os.remove(TEMP_FILE)
    else
        vim.notify("❌ Error pasting: " .. result, vim.log.levels.ERROR)
    end
end

-- Check if there's a file ready to paste
function M.has_cross_project_copy()
    return vim.fn.filereadable(TEMP_FILE) == 1
end

-- Clear the cross-project copy cache
function M.clear_cross_project_copy()
    if vim.fn.filereadable(TEMP_FILE) == 1 then
        os.remove(TEMP_FILE)
        vim.notify("📋 Cross-project copy cleared", vim.log.levels.INFO)
    else
        vim.notify("📋 No cross-project copy to clear", vim.log.levels.WARN)
    end
end

return M