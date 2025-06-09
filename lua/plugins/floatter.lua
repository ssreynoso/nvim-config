return {
    dir = vim.fn.stdpath("config") .. "/lua/modules/floatter",
    name = "floatter",
    config = function()
        local floatter = require("modules.floatter")

        vim.keymap.set("n", "<leader>t", floatter.toggle_terminal, { desc = "Toggle terminal" })
        vim.keymap.set("n", "<leader>n", floatter.toggle_note, { desc = "Toggle notepad" })

        vim.api.nvim_create_user_command("Floaterminal", floatter.toggle_terminal, {})
        vim.api.nvim_create_user_command("Floaternote", floatter.toggle_note, {})
    end,
}
