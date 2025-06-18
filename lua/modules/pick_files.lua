local M = {}

local path_utils = require("modules.path")

function M.pick_and_open_files()
    require("telescope.builtin").find_files({
        attach_mappings = function(prompt_bufnr, map)
            local actions = require("telescope.actions")
            local action_state = require("telescope.actions.state")

            local function open_selections()
                local picker = action_state.get_current_picker(prompt_bufnr)
                local selections = picker:get_multi_selection()

                actions.close(prompt_bufnr)

                local function open(entry)
                    if entry and entry.path then
                        local safe_path = path_utils.smart_escape_path(entry.path)
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

            map("i", "<CR>", open_selections)
            map("n", "<CR>", open_selections)

            return true
        end,
    })
end

return M
