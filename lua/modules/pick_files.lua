local M = {}

function M.pick_and_open_files()
    require("telescope.builtin").find_files({
        attach_mappings = function(_, map)
            local actions = require("telescope.actions")
            local action_state = require("telescope.actions.state")

            local function open_selections(prompt_bufnr)
                local picker = action_state.get_current_picker(prompt_bufnr)
                local selections = picker:get_multi_selection()

                actions.close(prompt_bufnr)

                if vim.tbl_isempty(selections) then
                    local entry = action_state.get_selected_entry()
                    if entry and entry.path then
                        vim.cmd("edit " .. vim.fn.fnameescape(entry.path))
                    end
                else
                    for _, entry in ipairs(selections) do
                        if entry and entry.path then
                            vim.cmd("edit " .. vim.fn.fnameescape(entry.path))
                        end
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
