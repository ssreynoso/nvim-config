return {
    "folke/zen-mode.nvim",
    config = function()
        require("zen-mode").setup({
            window = {
                width = 0.85, -- 85% del ancho de la pantalla
                options = {
                    number = true,
                    relativenumber = true,
                    wrap = false,
                },
            },
        })

        vim.keymap.set("n", "<leader>zz", function()
            require("zen-mode").toggle()
        end)
    end,
}
