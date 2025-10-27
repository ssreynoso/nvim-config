return {
    "williamboman/mason.nvim",
    event = "VeryLazy",
    dependencies = {
        "williamboman/mason-lspconfig.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        "neovim/nvim-lspconfig",
        "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
        local mason = require("mason")
        local mason_lspconfig = require("mason-lspconfig")
        local mason_tool_installer = require("mason-tool-installer")
        local cmp_nvim_lsp = require("cmp_nvim_lsp")
        local util = require("lspconfig.util")

        mason.setup({
            ui = {
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗",
                },
            },
        })

        mason_lspconfig.setup({
            ensure_installed = {
                "ts_ls",
                "eslint",
                "html",
                "cssls",
                "tailwindcss",
                "jsonls",
                "lua_ls",
                "graphql",
                "emmet_ls",
                "prismals",
                "rust_analyzer",
                "pyright",
            },
        })

        mason_tool_installer.setup({
            ensure_installed = {
                "prettier",
                "stylua",
                "eslint_d",
            },
            auto_update = false,
            run_on_start = true,
        })

        -- Configuración global: capabilities para todos los servers
        vim.lsp.config("*", {
            capabilities = cmp_nvim_lsp.default_capabilities(),
        })

        -- Configuraciones específicas por server
        vim.lsp.config.eslint = {
            root_markers = { ".eslintrc.js", ".eslintrc.json", ".eslintrc", "package.json" },
            settings = {
                format = { enable = true },
                codeActionOnSave = { enable = true, mode = "all" },
                workingDirectory = { mode = "auto" },
            },
        }

        vim.lsp.config.cssls = {
            root_markers = { "package.json", ".git" },
            filetypes = { "css", "scss", "less" },
        }

        vim.lsp.config.tailwindcss = {
            root_markers = { "tailwind.config.js", "tailwind.config.ts", "postcss.config.js", "package.json" },
        }

        vim.lsp.config.jsonls = {
            settings = {
                json = {
                    format = { enable = false },
                    validate = { enable = true },
                },
            },
        }

        vim.lsp.config.lua_ls = {
            settings = {
                Lua = {
                    diagnostics = { globals = { "vim" } },
                    completion = { callSnippet = "Replace" },
                },
            },
        }

        vim.lsp.config.graphql = {
            filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
        }

        vim.lsp.config.emmet_ls = {
            filetypes = {
                "html",
                "typescriptreact",
                "javascriptreact",
                "css",
                "sass",
                "scss",
                "less",
                "svelte",
            },
        }
    end,
}
