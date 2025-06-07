return {
    "rcarriga/nvim-notify",
    config = function()
        require("notify").setup({
            background_colour = "#000000",
            merge_duplicates = true, -- o false, según lo que prefieras
        })
        vim.notify = require("notify")
    end,
}
