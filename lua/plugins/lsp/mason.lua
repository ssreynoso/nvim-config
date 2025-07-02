
return {
    "williamboman/mason.nvim",
    version = "1.11.0",
    event = "VeryLazy", -- Lazy-loadea Mason (no hace falta que esté en cada buffer)
    dependencies = {
        {
            "williamboman/mason-lspconfig.nvim",
            version = "1.32.0",
        },
        {
            "WhoIsSethDaniel/mason-tool-installer.nvim",
        },
        "neovim/nvim-lspconfig",
        "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
        local mason = require("mason")
        local mason_lspconfig = require("mason-lspconfig")
        local mason_tool_installer = require("mason-tool-installer")

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
            automatic_installation = false,
            ensure_installed = {
                "ts_ls",
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

        -- Setup LSP handlers aquí para evitar dependencia circular
        local lspconfig = require("lspconfig")
        local cmp_nvim_lsp = require("cmp_nvim_lsp")
        local util = require("lspconfig.util")
        local capabilities = cmp_nvim_lsp.default_capabilities()

        mason_lspconfig.setup_handlers({
            ["eslint"] = function()
                lspconfig.eslint.setup({
                    capabilities = capabilities,
                    root_dir = util.root_pattern("tsconfig.json", "package.json", ".git"),
                    settings = {
                        workingDirectory = { mode = "auto" },
                    },
                })
            end,
            function(server_name)
                lspconfig[server_name].setup({
                    capabilities = capabilities,
                })
            end,
            ["jsonls"] = function()
                lspconfig.jsonls.setup({
                    capabilities = capabilities,
                    settings = {
                        json = {
                            format = { enable = false },
                            validate = { enable = true },
                        },
                    },
                })
            end,
            ["lua_ls"] = function()
                lspconfig.lua_ls.setup({
                    capabilities = capabilities,
                    settings = {
                        Lua = {
                            diagnostics = { globals = { "vim" } },
                            completion = { callSnippet = "Replace" },
                        },
                    },
                })
            end,
            ["graphql"] = function()
                lspconfig.graphql.setup({
                    capabilities = capabilities,
                    filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
                })
            end,
            ["emmet_ls"] = function()
                lspconfig.emmet_ls.setup({
                    capabilities = capabilities,
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
                })
            end,
        })
    end,
}
