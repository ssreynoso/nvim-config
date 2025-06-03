return {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "folke/todo-comments.nvim",
    },
    config = function()
        local telescope = require("telescope")
        local builtin = require("telescope.builtin")

        telescope.setup({
            defaults = {
                find_command = {
                    "fd",
                    "--type",
                    "f",
                    "--strip-cwd-prefix",
                    "--hidden",
                    "--exclude",
                    ".git",
                    "--exclude",
                    "node_modules",
                },
                layout_strategy = "horizontal",
                sorting_strategy = "ascending",
                winblend = 10,
                layout_config = {
                    horizontal = { width = 0.9 },
                    vertical = { width = 0.5 },
                },
                path_display = { "smart" },
                file_ignore_patterns = {
                    "%.git/", -- carpeta .git
                    "node_modules/", -- node_modules
                    "%.lock", -- archivos lock
                    "%.out",
                    "%.o", -- compilados
                },
            },
        })

        -- Keymaps
        vim.keymap.set("n", "<C-p>", function()
            builtin.find_files({ hidden = true, no_ignore = false })
        end, { desc = "[P]roject find files (con fd)" })
        vim.keymap.set("n", "<leader>pf", builtin.live_grep, { desc = "[F]ind text with grep" })
        vim.keymap.set("n", "<leader>ph", builtin.help_tags, { desc = "[H]elp" })
        vim.keymap.set("n", "<leader>pt", "<cmd>TodoTelescope<cr>", { desc = "Find todos" })
    end,
}
