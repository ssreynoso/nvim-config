local M = {}

local path_utils = require("modules.path")

-- Utilidad: finder “smart”
local function smart_find_files(opts)
    opts = opts or {}

    -- Forzamos un sorter válido aunque fzf esté roto
    local sorters = require("telescope.sorters")
    opts.sorter = sorters.get_fuzzy_file()

    -- Defaults sanos para repos grandes
    opts.initial_mode = "insert"
    opts.follow = true
    opts.hidden = true
    opts.no_ignore = true

    -- Si tenés fd/fdfind, usalo (mucho más rápido)
    if vim.fn.executable("fd") == 1 then
        opts.find_command = { "fd", "--type", "f", "--hidden", "--follow", "--no-ignore-vcs" }
    elseif vim.fn.executable("fdfind") == 1 then
        opts.find_command = { "fdfind", "--type", "f", "--hidden", "--follow", "--no-ignore-vcs" }
    end

    local builtin = require("telescope.builtin")

    -- Intentá primero git_files (ultra rápido). Si falla (no git o WSL path raro), caé a find_files.
    local ok = pcall(builtin.git_files, vim.tbl_extend("force", { show_untracked = true }, opts))
    if not ok then
        builtin.find_files(opts)
    end
end

function M.pick_and_open_files()
    smart_find_files({
        attach_mappings = function(prompt_bufnr, map)
            local actions = require("telescope.actions")
            local action_state = require("telescope.actions.state")

            local function open_selections()
                local picker = action_state.get_current_picker(prompt_bufnr)
                local selections = picker:get_multi_selection()

                actions.close(prompt_bufnr)

                local function open(entry)
                    -- En find_files el campo es `path`; en git_files también funciona
                    local p = entry and (entry.path or entry.filename)
                    if p then
                        local safe_path = path_utils.smart_escape_path(p)
                        vim.cmd("edit " .. safe_path)
                    end
                end

                if vim.tbl_isempty(selections) then
                    open(action_state.get_selected_entry())
                else
                    for _, entry in ipairs(selections) do
                        open(entry)
                    end
                end
            end

            -- Enter abre selección única o múltiples
            map("i", "<CR>", open_selections)
            map("n", "<CR>", open_selections)

            -- Conserva el resto de mapeos por defecto
            return true
        end,
    })
end

return M
