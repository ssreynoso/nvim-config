
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
    end,
}
