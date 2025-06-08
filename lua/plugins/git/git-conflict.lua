return {
    "akinsho/git-conflict.nvim",
    version = "*",
    config = true,
    keys = {
        -- Esto abre la *quickfix list* con los conflictos detectados
        { "<leader>gc", "<cmd>GitConflictListQf<CR>", desc = "Lista de conflictos" },
    },
}
