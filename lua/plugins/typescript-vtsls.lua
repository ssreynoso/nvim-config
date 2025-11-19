return {
    "yioneko/nvim-vtsls",
    dependencies = {
        "neovim/nvim-lspconfig",
    },
    ft = {
        "typescript",
        "typescriptreact",
        "javascript",
        "javascriptreact",
    },

    config = function()
        local lspconfig = require("lspconfig")
        local configs = require("lspconfig.configs")

        -- Registrar el server si no existe
        if not configs.vtsls then
            configs.vtsls = require("vtsls").lspconfig
        end

        lspconfig.vtsls.setup({
            settings = {
                vtsls = {
                    maxTsServerMemory = 2048,
                },

                typescript = {
                    inlayHints = {
                        parameterNames = { enabled = "all" },
                        parameterTypes = { enabled = true },
                        variableTypes = { enabled = true },
                        propertyDeclarationTypes = { enabled = true },
                        functionLikeReturnTypes = { enabled = true },
                        enumMemberValues = { enabled = true },
                    },
                },

                javascript = {
                    inlayHints = {
                        parameterNames = { enabled = "all" },
                        parameterTypes = { enabled = true },
                        variableTypes = { enabled = true },
                        propertyDeclarationTypes = { enabled = true },
                        functionLikeReturnTypes = { enabled = true },
                        enumMemberValues = { enabled = true },
                    },
                },
            },
        })
    end,
}
