return {
    "norcalli/nvim-colorizer.lua",
    ft = { "css", "scss", "html", "vue", "tsx", "jsx" },
    config = function()
        require("colorizer").setup({
            css = { css = false, css_fn = false },
            html = { names = false, rgb_fn = true },
            scss = { rgb_fn = true },
            vue = { rgb_fn = true },
            tsx = { rgb_fn = true },
        })

        vim.keymap.set("n", "<leader>tc", function()
            require("colorizer").toggle()
        end, { desc = "Toggle Colorizer" })
    end,
}
