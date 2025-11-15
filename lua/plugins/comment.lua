return {
    "numToStr/Comment.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local comment = require("Comment")

        comment.setup({
            pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
        })

        -- Comentarios inline (línea por línea)
        vim.keymap.set(
            "n",
            "<leader>q",
            "<Plug>(comment_toggle_linewise_current)",
            { desc = "Toggle comentario inline en línea actual" }
        )

        vim.keymap.set(
            "v",
            "<leader>q",
            "<Plug>(comment_toggle_linewise_visual)",
            { desc = "Toggle comentario inline en selección" }
        )

        -- Comentarios de bloque
        vim.keymap.set(
            "n",
            "<leader>Q",
            "<Plug>(comment_toggle_blockwise_current)",
            { desc = "Toggle comentario de bloque en línea actual" }
        )

        vim.keymap.set(
            "v",
            "<leader>Q",
            "<Plug>(comment_toggle_blockwise_visual)",
            { desc = "Toggle comentario de bloque en selección" }
        )
    end,
    dependencies = {
        "JoosepAlviste/nvim-ts-context-commentstring",
    },
}
