local M = {}

local selected_files = {}

function M.pick_files()
    require("telescope.builtin").find_files({
        attach_mappings = function(_, map)
            local actions = require("telescope.actions")
            local action_state = require("telescope.actions.state")

            local function collect_selections(prompt_bufnr)
                local picker = action_state.get_current_picker(prompt_bufnr)
                local selections = picker:get_multi_selection()

                if vim.tbl_isempty(selections) then
                    table.insert(selected_files, action_state.get_selected_entry().path)
                else
                    for _, entry in ipairs(selections) do
                        table.insert(selected_files, entry.path)
                    end
                end
                actions.close(prompt_bufnr)
                M.ask_for_destination()
            end

            map("i", "<CR>", collect_selections)
            map("n", "<CR>", collect_selections)

            return true
        end,
    })
end

function M.ask_for_destination()
    local cwd = vim.fn.getcwd()

    vim.ui.input({ prompt = "Destino (desde " .. cwd .. "): " }, function(dest)
        if not dest or dest == "" then
            vim.notify("move_files: Operación cancelada.", vim.log.levels.WARN)
            selected_files = {}
            return
        end

        -- 🚨 Validar si parece un archivo (termina en .ext)
        if dest:match(".*%..+$") then
            vim.notify("Parece que escribiste un archivo como destino. Se espera una carpeta.", vim.log.levels.ERROR)
            selected_files = {}
            return
        end

        local full_path = cwd .. "/" .. dest

        -- 📁 Crear carpeta completa si no existe (mkdir -p)
        if vim.fn.isdirectory(full_path) == 0 then
            local ok = vim.fn.mkdir(full_path, "p")
            if ok == 0 then
                vim.notify("No se pudo crear la carpeta destino: " .. full_path, vim.log.levels.ERROR)
                selected_files = {}
                return
            end
        end

        for _, file in ipairs(selected_files) do
            local filename = vim.fn.fnamemodify(file, ":t")
            local target = full_path .. "/" .. filename
            local ok, err = os.rename(file, target)
            if not ok then
                vim.notify("Error al mover " .. file .. ": " .. err, vim.log.levels.ERROR)
            end
        end

        vim.notify("Archivos movidos a: " .. full_path, vim.log.levels.INFO)
        selected_files = {}
    end)
end

return M
