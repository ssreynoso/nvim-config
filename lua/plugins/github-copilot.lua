-- ~/.config/nvim/lua/plugins/copilot.lua
return {
    "github/copilot.vim",
    event = "InsertEnter",
    config = function()
        -- 1. Desactivo el <Tab> que pone Copilot
        vim.g.copilot_no_tab_map = true
        vim.g.copilot_assume_mapped = true -- evita que Copilot se queje

        -- 2. Vuelvo a poner <Tab> a mano (acepta sugerencia o inserta tab)
        vim.keymap.set("i", "<Tab>", function()
            if vim.fn["copilot#GetDisplayedSuggestion"]().text ~= "" then
                vim.api.nvim_feedkeys(vim.fn["copilot#Accept"]("\r"), "n", true)
            else
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", true)
            end
        end, { silent = true })

        -- 3. Nuevo atajo: aceptar palabra
        vim.keymap.set("i", "<C-l>", "copilot#AcceptWord()", { expr = true, silent = true })

        -- 4. Toggle function for copilot autocompletion
        local function toggle_copilot()
            if vim.g.copilot_enabled == 0 then
                vim.cmd("Copilot enable")
                vim.g.copilot_enabled = 1
                print("GitHub Copilot enabled")
            else
                vim.cmd("Copilot disable")
                vim.g.copilot_enabled = 0
                print("GitHub Copilot disabled")
            end
        end

        -- 5. Keymap para toggle
        vim.keymap.set("n", "<leader>co", toggle_copilot, { desc = "Toggle GitHub Copilot" })

        -- 6. Initialize copilot as enabled by default
        vim.g.copilot_enabled = 1
    end,
}
