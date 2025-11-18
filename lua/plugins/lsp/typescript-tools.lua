return {
    "pmizio/typescript-tools.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "neovim/nvim-lspconfig",
    },
    ft = {
        "typescript",
        "typescriptreact",
        "javascript",
        "javascriptreact",
    },

    config = function()
        require("typescript-tools").setup({
            single_file_support = false,

            on_attach = function(client, bufnr)
                -- Deshabilitar formateo si usás Prettier
                client.server_capabilities.documentFormattingProvider = false
                client.server_capabilities.documentRangeFormattingProvider = false
            end,

            settings = {
                -- 👇 Fuerza que SOLO haya UN tsserver (evita 2 procesos gigantes)
                separate_diagnostic_server = false,

                -- 👇 Fija límite de memoria del tsserver (2GB suele ser suficiente)
                tsserver_max_memory = 2048,

                tsserver_file_preferences = {
                    includeInlayParameterNameHints = "all",
                    includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                    includeInlayFunctionParameterTypeHints = true,
                    includeInlayVariableTypeHints = true,
                    includeInlayVariableTypeHintsWhenTypeMatchesName = false,
                    includeInlayPropertyDeclarationTypeHints = true,
                    includeInlayFunctionLikeReturnTypeHints = true,
                    includeInlayEnumMemberValueHints = true,
                },

                -- Plugins extra de tsserver (si usás styled-components, etc)
                tsserver_plugins = {},
            },
        })
    end,
}
