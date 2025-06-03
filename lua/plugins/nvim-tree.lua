return {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    dependencies = {
        "nvim-tree/nvim-web-devicons", -- íconos
    },
    init = function()
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1
        require("keymaps.nvim-tree").setup()
    end,
    config = function()
        require("nvim-tree").setup({
            view = {
                side = "right",
                width = 40,
                preserve_window_proportions = true,
            },
            renderer = {
                icons = {
                    show = {
                        file = true,
                        folder = true,
                        folder_arrow = true,
                        git = false,
                    },
                },
            },
            filters = {
                git_ignored = false,
                dotfiles = false,
            },
        })
    end,
}
