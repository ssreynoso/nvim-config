local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local conf = require("telescope.config").values

local M = {}

function M.GitBranchSelector()
    local Job = require("plenary.job")
    Job:new({
        command = "git",
        args = { "branch", "--color=never" },
        on_exit = function(j)
            vim.schedule(function()
                local raw_lines = j:result()
                local current_branch
                local entries = {}

                for _, line in ipairs(raw_lines) do
                    local is_current = line:match("^%*")
                    local branch_name = vim.trim(line:gsub("^%*", ""))
                    if is_current then
                        current_branch = branch_name
                    end

                    table.insert(entries, {
                        name = branch_name,
                        display = is_current and ("* " .. branch_name) or ("  " .. branch_name),
                        is_current = is_current,
                    })
                end

                local entry_display = require("telescope.pickers.entry_display").create({
                    separator = " ",
                    items = {
                        { width = 2 },
                        { remaining = true },
                    },
                })

                local function make_entry(entry)
                    return {
                        value = entry.name,
                        ordinal = entry.name,
                        display = function()
                            local prefix = entry.is_current and "*" or " "
                            local hl_group = entry.is_current and "Keyword" or nil -- o usa otro grupo
                            return entry_display({
                                { prefix, hl_group },
                                { entry.name, hl_group },
                            })
                        end,
                    }
                end

                pickers
                    .new({
                        layout_strategy = "center",
                        layout_config = { width = 0.4, height = 0.5 },
                        prompt_title = "Git branches",
                        initial_mode = "normal",
                    }, {
                        finder = finders.new_table({
                            results = entries,
                            entry_maker = make_entry,
                        }),
                        sorter = conf.generic_sorter({}),
                        attach_mappings = function(prompt_bufnr, map)
                            actions.select_default:replace(function()
                                actions.close(prompt_bufnr)
                                local selection = action_state.get_selected_entry()
                                if selection and selection.value then
                                    vim.cmd("silent !git checkout " .. selection.value)
                                    vim.notify("Switched to branch: " .. selection.value, vim.log.levels.INFO)
                                end
                            end)
                            return true
                        end,
                    })
                    :find()
            end)
        end,
    }):start()
end

return M
