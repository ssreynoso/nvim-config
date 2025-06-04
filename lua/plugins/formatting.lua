return {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local conform = require("conform")

        -- Detectar si hay un .prettierrc en el root actual
        local prettier_args = nil
        local prettierrc_files = {
            ".prettierrc",
            ".prettierrc.json",
            ".prettierrc.js",
            ".prettierrc.cjs",
            "prettier.config.js",
            "prettier.config.cjs",
        }

        for _, file in ipairs(prettierrc_files) do
            if vim.fn.filereadable(vim.fn.getcwd() .. "/" .. file) == 1 then
                prettier_args = {}
                break
            end
        end

        if not prettier_args then
            prettier_args = {
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
            }
        end

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
                    prepend_args = prettier_args,
                    prefer_local = "node_modules/.bin",
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
