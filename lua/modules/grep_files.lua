local M = {}

local path_utils = require("modules.path")

function M.grep_and_open_files()
    require("telescope.builtin").live_grep({
        attach_mappings = function(prompt_bufnr, map)
            local actions = require("telescope.actions")
            local action_state = require("telescope.actions.state")

            local function open_selections()
                local picker = action_state.get_current_picker(prompt_bufnr)
                local selections = picker:get_multi_selection()

                actions.close(prompt_bufnr)

                local function open(entry)
                    if entry and entry.filename then
                        local safe_path = path_utils.smart_escape_path(entry.filename)
                        -- Abrir archivo y ir a la línea específica
                        vim.cmd("edit " .. safe_path)
                        if entry.lnum then
                            vim.api.nvim_win_set_cursor(0, { entry.lnum, entry.col or 0 })
                        end
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