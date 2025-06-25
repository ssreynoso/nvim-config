-- ~/.config/nvim/ly ua/plugins/treesitter.lua
return {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    lazy = false,
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter.configs").setup({
            ensure_installed = {
                "javascript",
                "typescript",
                "tsx", -- JSX/TSX (React)
                "html",
                "css",
                "json",
                "jsonc", -- para archivos como tsconfig.json o .eslintrc
                "yaml", -- por ejemplo en workflows o configs
                "lua", -- por tu config de neovim
                "bash", -- útil para scripts y terminal
                "markdown", -- para documentación o notas
                "markdown_inline",
                "vim", -- ayuda con sintaxis de vimrc o plugins antiguos
                "query", -- requerido por treesitter para plugins que analizan árboles
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

            context_commentstring = {
                enable = true,
                enable_autocmd = false, -- dejalo en false si usás pre_hook
            },
        })
    end,
}
