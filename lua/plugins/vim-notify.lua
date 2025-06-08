return {
    "rcarriga/nvim-notify",
    config = function()
        require("notify").setup({
            background_colour = "#000000",
            merge_duplicates = true, -- o false
            max_width = 60, -- ancho máximo en caracteres
            stages = "fade",
            timeout = 1500, -- 3 segundos (3000 ms)
        })
        vim.notify = require("notify")
    end,
}
