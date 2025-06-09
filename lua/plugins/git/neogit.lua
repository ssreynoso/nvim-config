return {
    "NeogitOrg/neogit",
    cmd = "Neogit",
    keys = {
        { "<leader>gs", "<cmd>Neogit<CR>", desc = "Abrir Neogit" },
    },
    dependencies = {
        "nvim-lua/plenary.nvim",
        {
            "sindrets/diffview.nvim",
            config = true, -- se integra automáticamente
        },
    },
    config = function()
        require("neogit").setup({
            kind = "tab", -- o "split", "floating"
            integrations = {
                diffview = true,
            },
        })
    end,
}

-- Prueba de comentario
