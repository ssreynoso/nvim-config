return {
    "numToStr/Comment.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local comment = require("Comment")

        comment.setup({
            pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
        })

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
