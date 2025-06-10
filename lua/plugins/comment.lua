return {
    "numToStr/Comment.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local comment = require("Comment")

        comment.setup({
            -- Solo se inyecta el hook si estamos en filetypes que lo requieren
            pre_hook = function(ctx)
                local ft = vim.bo.filetype
                local supported = {
                    typescriptreact = true,
                    javascriptreact = true,
                    vue = true,
                    astro = true,
                    svelte = true,
                }
                if supported[ft] then
                    local ts_context_commentstring = require("ts_context_commentstring.integrations.comment_nvim")
                    return ts_context_commentstring.create_pre_hook()(ctx)
                end
            end,
        })

        -- Atajos
        vim.keymap.set("n", "<leader>q", "<Plug>(comment_toggle_linewise_current)", { desc = "Comentar línea actual" })
        vim.keymap.set("n", "<C-q>", "<Plug>(comment_toggle_linewise_current)", { desc = "Comentar línea actual" })
        vim.keymap.set("v", "<C-q>", "<Plug>(comment_toggle_linewise_visual)", { desc = "Comentar selección" })
        vim.keymap.set("v", "<leader>q", "<Plug>(comment_toggle_linewise_visual)", { desc = "Comentar selección" })
    end,
    dependencies = {
        "JoosepAlviste/nvim-ts-context-commentstring",
    },
}
