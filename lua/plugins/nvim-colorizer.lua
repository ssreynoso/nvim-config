return {
    "norcalli/nvim-colorizer.lua",
    event = "BufReadPost",
    config = function()
        require("colorizer").setup({
            "*", -- Enable for all filetypes
        }, {
            RGB = true,      -- #RGB hex codes
            RRGGBB = true,   -- #RRGGBB hex codes
            names = false,   -- "Name" codes like Blue
            RRGGBBAA = true, -- #RRGGBBAA hex codes
            rgb_fn = true,   -- CSS rgb() and rgba() functions
            hsl_fn = true,   -- CSS hsl() and hsla() functions
            css = true,      -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
            css_fn = true,   -- Enable all CSS *functions*: rgb_fn, hsl_fn
            mode = "background", -- Set the display mode
        })

        vim.keymap.set("n", "<leader>tc", function()
            require("colorizer").toggle()
        end, { desc = "Toggle Colorizer" })
    end,
}
