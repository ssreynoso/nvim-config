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
                "jsonc",
                "yaml",
                "lua",
                "bash",
                "markdown",
                "markdown_inline",
                "vim",
                "query",
                "prisma",
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
