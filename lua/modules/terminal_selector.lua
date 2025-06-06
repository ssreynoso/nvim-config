local M = {}

local possible_shells = {
    { id = "powershell", name = "PowerShell", icon = "" },
    { id = "cmd", name = "CMD", icon = "" },
    { id = "pwsh", name = "PowerShell Core", icon = "" },
    { id = "bash", name = "Git Bash / Bash", icon = "" },
    { id = "wsl", name = "WSL", icon = "󰻿" },
}

function M.select_terminal(callback)
    local available = {}
    for _, shell in ipairs(possible_shells) do
        if vim.fn.executable(shell.id) == 1 then
            table.insert(available, shell)
        end
    end

    if #available == 0 then
        vim.notify("No se encontraron terminales disponibles", vim.log.levels.ERROR)
        return
    elseif #available == 1 then
        callback(available[1].id)
    else
        local pickers = require("telescope.pickers")
        local finders = require("telescope.finders")
        local actions = require("telescope.actions")
        local action_state = require("telescope.actions.state")
        local conf = require("telescope.config").values

        pickers
            .new({
                layout_strategy = "center",
                layout_config = {
                    width = 0.3,
                    height = 0.4,
                },
                initial_mode = "normal",
            }, {
                prompt_title = "Select a terminal",
                results_title = false,
                preview_title = false,
                finder = finders.new_table({
                    results = available,
                    entry_maker = function(entry)
                        return {
                            value = entry.id,
                            display = string.format("%s  %s (%s)", entry.icon, entry.name, entry.id),
                            ordinal = entry.name .. entry.id,
                        }
                    end,
                }),
                sorter = conf.generic_sorter({}),
                attach_mappings = function(prompt_bufnr, map)
                    actions.select_default:replace(function()
                        actions.close(prompt_bufnr)
                        local selection = action_state.get_selected_entry()
                        callback(selection.value)
                    end)
                    return true
                end,
            })
            :find()
    end
end

return M
