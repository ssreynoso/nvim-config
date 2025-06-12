return {
    "numToStr/Comment.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local comment = require("Comment")

        comment.setup()

        vim.keymap.set(
            "n",
            "<leader>q",
            "<Plug>(comment_toggle_linewise_current)",
            { desc = "Comentar línea actual (linewise)" }
        )

        vim.keymap.set(
            "v",
            "<leader>q",
            "<Plug>(comment_toggle_blockwise_visual)",
            { desc = "Comentar selección (blockwise)" }
        )
    end,
    dependencies = {
        "JoosepAlviste/nvim-ts-context-commentstring",
    },
}
