return {
    "norcalli/nvim-colorizer.lua",
    config = function()
        require("colorizer").setup({
            -- habilitar para todos los tipos de archivos
            "*",
            -- solo hexadecimales y rgb/rgba
            css = { css = false, css_fn = false },
            html = { names = false, rgb_fn = true },
        })
        -- también podés mapear un toggle:
        vim.keymap.set("n", "<leader>tc", function()
            require("colorizer").toggle()
        end, { desc = "Toggle Colorizer" })
    end,
}
