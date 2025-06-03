return {
    {
        "williamboman/mason.nvim",
        version = "1.11.0",
        dependencies = {
            {
                "williamboman/mason-lspconfig.nvim",
                version = "1.32.0",
            },
            "WhoIsSethDaniel/mason-tool-installer.nvim",
        },
        config = function()
            -- Importar plugins
            local mason = require("mason")
            local mason_lspconfig = require("mason-lspconfig")
            local mason_tool_installer = require("mason-tool-installer")
            local lspconfig = require("lspconfig")
            local cmp_nvim_lsp = require("cmp_nvim_lsp")

            -- Configurar Mason
            mason.setup({
                ui = {
                    icons = {
                        package_installed = "✓",
                        package_pending = "➜",
                        package_uninstalled = "✗",
                    },
                },
            })

            -- Configurar Mason LSPConfig
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

            -- Configurar Mason Tool Installer
            mason_tool_installer.setup({
                ensure_installed = {
                    "prettier",
                    "stylua",
                    "eslint_d",
                },
            })

            -- Configurar capacidades de autocompletado
            local capabilities = cmp_nvim_lsp.default_capabilities()

            -- Configurar handlers para servidores LSP
            mason_lspconfig.setup_handlers({
                function(server_name)
                    lspconfig[server_name].setup({
                        capabilities = capabilities,
                    })
                end,
                ["jsonls"] = function()
                    lspconfig.jsonls.setup({
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
    },
}
