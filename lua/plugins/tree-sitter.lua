return {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    lazy = false,
    build = ":TSUpdate",
    config = function()
        vim.g.skip_ts_context_commentstring_module = true

        require("nvim-treesitter.configs").setup({
            ensure_installed = {
                "javascript",
                "typescript",
                "tsx",
                "html",
                "css",
                "json",
                -- "jsonc", -- Comentado temporalmente debido a problemas de descarga
                "yaml",
                "lua",
                "bash",
                "markdown",
                "markdown_inline",
                "vim",
                "query",
                "prisma",
            },

            -- Compilar desde código fuente en lugar de descargar binarios precompilados
            install = {
                prefer_git = true,
                compilers = { "gcc", "clang" },
            },

            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
            },

            indent = {
                enable = true,
            },

            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "gnn",
                    node_incremental = "grn",
                    node_decremental = "grm",
                },
            },
        })
    end,
}
