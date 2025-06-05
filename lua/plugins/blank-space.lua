return {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
        indent = {
            char = "·",
        },
        scope = {
            enabled = false, -- Desactiva las líneas verticales entre bloques de código (opcional)
        },
        whitespace = {
            remove_blankline_trail = false, -- No borra espacios, solo los muestra
        },
        exclude = {
            filetypes = {
                "help",
                "dashboard",
                "lazy",
                "NvimTree",
                "Trouble",
                "mason",
                "",
            },
        },
    },
}
