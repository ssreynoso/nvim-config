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
        local api = require("nvim-tree.api")

        nvim_tree.setup({
            view = {
                side = "left",
                width = 35,
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
            filters = {
                dotfiles = false, -- muestra todos los "dotfiles", incluido .env
                git_ignored = false, -- opcional: también muestra ignorados por Git
            },
            on_attach = function(bufnr)
                -- ✅ Mapeos por defecto
                api.config.mappings.default_on_attach(bufnr)

                -- ✅ Cross-project copy module
                local cross_project = require("modules.cross-project-copy")

                -- ✅ Opciones comunes para tus keymaps personalizados
                local opts = { buffer = bufnr, noremap = true, silent = true, nowait = true }

                -- ✅ Copiar para usar entre proyectos (Cross-project copy)
                vim.keymap.set("n", "<leader>cc", function()
                    local node = api.tree.get_node_under_cursor()
                    cross_project.copy_for_cross_project(node)
                end, vim.tbl_extend("force", opts, { desc = "Copy for cross-project use" }))

                -- ✅ Pegar desde otros proyectos (Cross-project paste)
                vim.keymap.set("n", "<leader>pp", function()
                    local node = api.tree.get_node_under_cursor()
                    cross_project.paste_from_cross_project(node, api)
                end, vim.tbl_extend("force", opts, { desc = "Paste from cross-project copy" }))

                vim.keymap.set("n", "<Tab>", function()
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
