return {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        {
            "nvim-telescope/telescope-fzf-native.nvim",
            build = "make",
        },
        "folke/todo-comments.nvim",
        "xiyaowong/telescope-emoji.nvim",
    },
    config = function()
        local telescope = require("telescope")
        local actions = require("telescope.actions")
        local transform_mod = require("telescope.actions.mt").transform_mod

        -- Icons
        local devicons = require("nvim-web-devicons")

        local trouble = require("trouble")
        local trouble_telescope = require("trouble.sources.telescope")

        -- or create your custom action
        local custom_actions = transform_mod({
            open_trouble_qflist = function(prompt_bufnr)
                trouble.toggle("quickfix")
            end, -- Customizar cómo se muestran los nombres
        })

        telescope.setup({
            defaults = {
                sorting_strategy = "ascending",
                layout_strategy = "horizontal",
                layout_config = {
                    horizontal = { width = 0.9 },
                },
                path_display = { "smart" },
                mappings = {
                    i = {
                        ["<C-k>"] = actions.move_selection_previous,
                        ["<C-j>"] = actions.move_selection_next,
                        ["<C-q>"] = actions.send_selected_to_qflist + custom_actions.open_trouble_qflist,
                        ["<C-t>"] = trouble_telescope.open,
                    },
                },
            },
            pickers = {
                buffers = {
                    sort_mru = true,
                    ignore_current_buffer = true,
                    previewer = false,
                    initial_mode = "normal",
                    layout_config = {
                        width = 0.5,
                        height = 0.7,
                    },
                    mappings = {
                        i = {
                            ["<c-d>"] = require("telescope.actions").delete_buffer,
                        },
                        n = {
                            ["<c-d>"] = require("telescope.actions").delete_buffer,
                        },
                    },
                    entry_maker = function(entry)
                        local bufname = vim.api.nvim_buf_get_name(entry.bufnr)
                        local basename = vim.fn.fnamemodify(bufname, ":t")
                        local icon, icon_hl = devicons.get_icon(basename, nil, { default = true })
                        local is_modified = vim.api.nvim_buf_get_option(entry.bufnr, "modified")
                        local modified = is_modified and " [+]" or ""
                        
                        -- Smart path display como en Ctrl+P
                        local smart_path = require("telescope.utils").transform_path({
                            path_display = { "smart" }
                        }, bufname)

                        return {
                            value = entry,
                            display = function()
                                return string.format(" %s  %s%s", icon, smart_path, modified)
                            end,
                            ordinal = smart_path .. modified,
                            bufnr = entry.bufnr,
                            icon = icon,
                            icon_hl_group = icon_hl,
                        }
                    end,
                },
                treesitter = {
                    initial_mode = "normal",
                },
                lsp_definitions = {
                    initial_mode = "normal",
                },
                lsp_type_definitions = {
                    initial_mode = "normal",
                },
                lsp_references = {
                    initial_mode = "normal",
                },
                lsp_implementations = {
                    initial_mode = "normal",
                },
            },
        })

        telescope.load_extension("fzf")
        telescope.load_extension("emoji")

        -- set keymaps
        local keymap = vim.keymap -- for conciseness

        keymap.set("n", "<leader>p", function()
            require("telescope.builtin").find_files({
                hidden = true, -- incluir dotfiles
                no_ignore = true, -- ignora .gitignore, .ignore, etc.
                prompt_title = "Buscar archivos (incluye ocultos)",
            })
        end, { desc = "Buscar archivos (todos)" })
        keymap.set("n", "<leader>pf", function()
            require("modules.grep_files").grep_and_open_files()
        end, { desc = "Find string in cwd (multi-select)" })
        keymap.set("n", "<leader>ph", "<cmd>Telescope help_tags<cr>", { desc = "Find string under cursor in cwd" })
        keymap.set("n", "<leader>pt", "<cmd>TodoTelescope<cr>", { desc = "Find todos" })
        keymap.set("n", "<leader>pb", "<cmd>Telescope buffers<cr>", { desc = "Buscar entre buffers abiertos" })
        keymap.set("n", "<leader>pe", function()
            require("telescope.builtin").find_files({
                hidden = true,
                no_ignore = true,
                prompt_title = "Buscar .env*",
                search_dirs = { vim.loop.cwd() }, -- opcional, limita a tu cwd
                find_command = (function()
                    local bin = vim.fn.executable("fd") == 1 and "fd"
                        or (vim.fn.executable("fdfind") == 1 and "fdfind")
                        or nil -- dejar que Telescope elija lo que haya
                    if bin then
                        return { bin, "--type", "f", "--hidden", "--no-ignore", "-g", ".env*" }
                    end
                    -- Si no hay fd, Telescope caerá en rg/find automáticamente.
                end)(),
            })
        end, { desc = "Buscar archivos .env*" })

        -- Quicktype + paste.
        vim.api.nvim_create_user_command("PasteAsCode", function()
            require("modules.quicktype").setup()
            vim.cmd("PasteAsCode")
        end, {})

        vim.keymap.set("n", "<leader>pq", "<cmd>PasteAsCode<CR>", { desc = "Pegar JSON como código con quicktype" })

        vim.keymap.set(
            "n",
            "<leader>gb",
            require("modules.git-branch-selector").GitBranchSelector,
            { desc = "Pick git branch (custom)" }
        )

        vim.keymap.set("n", "<leader>P", function()
            require("telescope.builtin").commands()
        end, { desc = "Command Palette estilo VSCode" })

        vim.keymap.set("n", "<leader>f", function()
            require("telescope.builtin").treesitter()
        end, { desc = "Buscar símbolos con Treesitter en el buffer actual" })

        -- Emoji picker
        vim.keymap.set("n", "<leader>i", function()
            require("telescope").extensions.emoji.emoji({
                attach_mappings = function(prompt_bufnr, map)
                    local function emoji_insert()
                        local selection = require("telescope.actions.state").get_selected_entry()
                        require("telescope.actions").close(prompt_bufnr)
                        
                        if selection and selection.value then
                            -- Copiar el emoji al registro del sistema
                            vim.fn.setreg('*', selection.value)
                            vim.fn.setreg('+', selection.value)
                            -- Pegar inmediatamente
                            vim.api.nvim_feedkeys('"*p', 'n', false)
                        end
                    end
                    
                    map("i", "<CR>", emoji_insert)
                    map("n", "<CR>", emoji_insert)
                    return true
                end,
            })
        end, { desc = "Pick emoji" })

        -- Keymaps con toggle
        local toggles = require("modules.telescope_toggles")
        vim.keymap.set("n", "<leader>b", toggles.toggle_buffers, { desc = "Toggle Buffers" })
        vim.keymap.set("n", "<leader>m", toggles.toggle_treesitter, { desc = "Toggle Símbolos (treesitter)" })
    end,
}
