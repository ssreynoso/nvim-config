return {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local conform = require("conform")

        conform.setup({
            formatters_by_ft = {
                javascript = { "prettier" },
                typescript = { "prettier" },
                javascriptreact = { "prettier" },
                typescriptreact = { "prettier" },
                svelte = { "prettier" },
                css = { "prettier" },
                html = { "prettier" },
                json = { "prettier" },
                yaml = { "prettier" },
                markdown = { "prettier" },
                graphql = { "prettier" },
                liquid = { "prettier" },
                lua = { "stylua" },
                python = { "isort", "black" },
            },
            formatters = {
                prettier = {
                    prepend_args = {
                        "--print-width",
                        "100",
                        "--trailing-comma",
                        "all",
                        "--tab-width",
                        "2",
                        "--semi",
                        "true",
                        "--single-quote",
                        "false",
                        "--jsx-single-quote",
                        "false",
                        "--bracket-spacing",
                        "true",
                        "--arrow-parens",
                        "always",
                        "--end-of-line",
                        "auto",
                        "--quote-props",
                        "as-needed",
                    },
                },
            },
            format_on_save = {
                lsp_fallback = true,
                async = false,
                timeout_ms = 2000,
            },
        })

        vim.keymap.set({ "n", "v" }, "<leader>I", function()
            conform.format({
                lsp_fallback = true,
                async = false,
                timeout_ms = 2000,
            })
        end, { desc = "Format file or range (in visual mode)" })
    end,
}
