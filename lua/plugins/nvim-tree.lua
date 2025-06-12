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
        local nvim_tree = require("nvim-tree")

        nvim_tree.setup({
            view = {
                side = "left",
                width = 50,
                preserve_window_proportions = true,
            },
            update_focused_file = {
                enable = true,
                update_root = false,
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
            on_attach = function()
                vim.keymap.set("n", "<Tab>", function()
                    local api = require("nvim-tree.api")
                    local node = api.tree.get_node_under_cursor()

                    if node and node.name == ".." then
                        vim.notify("--> You can't navigate to a parent directory.", vim.log.levels.WARN)
                        return
                    end

                    api.node.open.edit()
                end, opts)
            end,
        })
    end,
}
