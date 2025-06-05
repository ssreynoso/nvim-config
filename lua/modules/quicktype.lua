-- ~/.config/nvim/lua/modules/quicktype.lua
local M = {}

function M.setup()
    vim.api.nvim_create_user_command("PasteAsCode", function()
        if vim.fn.executable("quicktype") == 0 then
            vim.notify("quicktype no está instalado (npm install -g quicktype)", vim.log.levels.ERROR)
            return
        end

        local content = vim.fn.getreg("+")
        if not content or content == "" then
            vim.notify("El portapapeles está vacío", vim.log.levels.ERROR)
            return
        end

        local ok, parsed = pcall(vim.fn.json_decode, content)
        if not ok or type(parsed) ~= "table" then
            vim.notify("El contenido no parece un JSON válido", vim.log.levels.ERROR)
            return
        end

        local loader = require("modules.loader")

        local pickers = require("telescope.pickers")
        local finders = require("telescope.finders")
        local actions = require("telescope.actions")
        local action_state = require("telescope.actions.state")
        local conf = require("telescope.config").values

        local langs = {
            { name = "TypeScript", icon = "󰛦", id = "ts" },
            { name = "C#", icon = "󰌛", id = "cs" },
            { name = "Go", icon = "", id = "go" },
            { name = "Java", icon = "󰬷", id = "java" },
            { name = "Kotlin", icon = "󱈙", id = "kotlin" },
            { name = "Dart", icon = "", id = "dart" },
            { name = "Swift", icon = "", id = "swift" },
            { name = "C++", icon = "", id = "cpp" },
            { name = "Python", icon = "", id = "python" },
            { name = "Ruby", icon = "", id = "ruby" },
        }

        pickers
            .new({}, {
                prompt_title = "Elegí el lenguaje",
                finder = finders.new_table({
                    results = langs,
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

                        local close_loader = loader.show_loader(" Generando código...")
                        vim.cmd("redraw")

                        local tmpfile = os.tmpname() .. ".json"
                        local outfile = os.tmpname() .. ".txt"
                        vim.fn.writefile(vim.fn.split(content, "\n"), tmpfile)

                        local cmd =
                            string.format("quicktype %s -l %s -o %s --just-types", tmpfile, selection.value, outfile)
                        os.execute(cmd)

                        close_loader()

                        local result = vim.fn.readfile(outfile)
                        vim.api.nvim_put(result, "l", true, true)

                        vim.notify("Código generado con éxito para " .. selection.value, vim.log.levels.INFO)
                    end)
                    return true
                end,
            })
            :find()
    end, {})
end

return M
