return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
    },
    config = function()
        local harpoon = require("harpoon")
        harpoon:setup({})

        local map = vim.keymap.set

        -- Variable para trackear el picker actual
        local current_picker = nil

        -- Telescope picker for harpoon
        local function harpoon_telescope_picker()
            -- Si hay un picker abierto, cerrarlo
            if current_picker then
                require("telescope.actions").close(current_picker.prompt_bufnr)
                current_picker = nil
                return
            end

            local pickers = require("telescope.pickers")
            local finders = require("telescope.finders")
            local conf = require("telescope.config").values
            local actions = require("telescope.actions")
            local action_state = require("telescope.actions.state")

            local list = harpoon:list()
            local items = list.items

            local entries = {}
            for i, item in ipairs(items) do
                local path = item.value or ""
                local short = vim.fn.fnamemodify(path, ":.")
                table.insert(entries, {
                    idx = i,
                    display = string.format("%d: %s", i, short),
                    path = path,
                })
            end

            -- Crear y mostrar el picker
            local picker = pickers.new({}, {
                prompt_title = "Harpoon Files",
                initial_mode = "normal",
                layout_strategy = "center",
                layout_config = { width = 0.5, height = 0.4 },
                finder = finders.new_table({
                    results = entries,
                    entry_maker = function(e)
                        return {
                            value = e,
                            display = e.display,
                            ordinal = e.display .. " " .. e.path,
                        }
                    end,
                }),
                sorter = conf.generic_sorter({}),
                attach_mappings = function(prompt_bufnr, map)
                    current_picker = { prompt_bufnr = prompt_bufnr }

                    -- Hook para limpiar cuando el picker se cierre
                    vim.api.nvim_buf_attach(prompt_bufnr, false, {
                        on_detach = function()
                            current_picker = nil
                        end,
                    })

                    actions.select_default:replace(function()
                        local selection = action_state.get_selected_entry()
                        actions.close(prompt_bufnr)
                        if selection and selection.value and selection.value.idx then
                            list:select(selection.value.idx)
                        end
                    end)

                    local function remove_selected_item()
                        local selection = action_state.get_selected_entry()
                        if selection and selection.value and selection.value.idx then
                            local file_path = selection.value.path
                            local filename = vim.fn.fnamemodify(file_path, ":t")
                            list:remove_at(selection.value.idx)
                            vim.notify("Removed '" .. filename .. "' from Harpoon", vim.log.levels.WARN, { title = "Harpoon" })
                            current_picker = nil -- Resetear antes de cerrar
                            actions.close(prompt_bufnr)
                            vim.defer_fn(function()
                                harpoon_telescope_picker()
                            end, 10)
                        end
                    end

                    map("i", "<C-d>", remove_selected_item)
                    map("n", "d", remove_selected_item)

                    return true
                end,
            })

            picker:find()
        end

        -- Agregar archivo con notificación
        local function add_file_with_notification()
            harpoon:list():add()
            local current_file = vim.fn.expand("%:t")
            if current_file ~= "" then
                vim.notify("Added '" .. current_file .. "' to Harpoon", vim.log.levels.INFO, { title = "Harpoon" })
            else
                vim.notify("Added current buffer to Harpoon", vim.log.levels.INFO, { title = "Harpoon" })
            end
        end

        map("n", "<C-h>", add_file_with_notification, { desc = "Harpoon add file" })

        -- Menú con Telescope (fallback al nativo)
        map("n", "<C-e>", function()
            local ok, _ = pcall(require, "telescope")
            if ok then
                harpoon_telescope_picker()
            else
                harpoon.ui:toggle_quick_menu(harpoon:list())
            end
        end, { desc = "Harpoon menu (Telescope)" })
    end,
}
