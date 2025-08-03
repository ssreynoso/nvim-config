-- ~/.config/nvim/lua/plugins/copilot.lua
return {
    "github/copilot.vim",
    event = "InsertEnter",
    config = function()
        -- 1. Desactivo el <Tab> que pone Copilot
        vim.g.copilot_no_tab_map = true
        vim.g.copilot_assume_mapped = true -- evita que Copilot se queje

        -- 2. Vuelvo a poner <Tab> a mano (acepta todo)
        vim.keymap.set("i", "<Tab>", "copilot#Accept('<CR>')", { expr = true, silent = true, replace_keycodes = false })

        -- 3. Nuevo atajo: aceptar palabra
        vim.keymap.set("i", "<C-l>", "copilot#AcceptWord()", { expr = true, silent = true })
    end,
}
