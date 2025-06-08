return {
    "kdheepak/lazygit.nvim",
    cmd = "LazyGit",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
        {
            "<leader>gg",
            function()
                require("modules.floatter").toggle_lazygit()
            end,
            desc = "Abrir Lazygit en terminal flotante",
        },
    },
}
