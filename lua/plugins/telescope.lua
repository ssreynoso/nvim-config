return {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        {
            "nvim-telescope/telescope-fzf-native.nvim",
            -- Windows: usá CMake (no `make`)
            build = table.concat({
                "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release",
                "cmake --build build --config Release",
                "cmake --install build --prefix build",
            }, " && "),
        },
        "folke/todo-comments.nvim",
        "xiyaowong/telescope-emoji.nvim",
    },

    -- Autoload por teclas
    keys = {
        {
            "<leader>p",
            function()
                local builtin = require("telescope.builtin")
                -- intentá git_files (rápido); si falla, fallback a find_files
                local ok = pcall(builtin.git_files, {
                    show_untracked = true,
                    prompt_title = "Git files (incluye untracked)",
                })
                if not ok then
                    builtin.find_files({
                        hidden = true,
                        no_ignore = true,
                        follow = true,
                        prompt_title = "Buscar archivos (incluye ocultos)",
                        find_command = (function()
                            if vim.fn.executable("fd") == 1 then
                                return { "fd", "--type", "f", "--hidden", "--follow", "--no-ignore-vcs" }
                            elseif vim.fn.executable("fdfind") == 1 then
                                return { "fdfind", "--type", "f", "--hidden", "--follow", "--no-ignore-vcs" }
                            end
                        end)(),
                    })
                end
            end,
            desc = "Buscar archivos (smart)",
        },
        { "<leader>pf", function() require("modules.grep_files").grep_and_open_files() end, desc = "Find string in cwd (multi-select)" },
        { "<leader>ph", "<cmd>Telescope help_tags<cr>",                                     desc = "Ayuda" },
        { "<leader>pt", "<cmd>TodoTelescope<cr>",                                           desc = "Find TODOs" },
        { "<leader>pb", "<cmd>Telescope buffers<cr>",                                       desc = "Buffers abiertos" },
        {
            "<leader>pe",
            function()
                require("telescope.builtin").find_files({
                    hidden = true,
                    no_ignore = true,
                    prompt_title = "Buscar .env*",
                    search_dirs = { vim.loop.cwd() },
                    find_command = (function()
                        local bin = (vim.fn.executable("fd") == 1 and "fd") or
                        (vim.fn.executable("fdfind") == 1 and "fdfind") or nil
                        if bin then
                            return { bin, "--type", "f", "--hidden", "--no-ignore", "-g", ".env*" }
                        end
                    end)(),
                })
            end,
            desc = "Buscar archivos .env*",
        },
        { "<leader>pq", "<cmd>PasteAsCode<CR>",                                                    desc = "Pegar JSON como código (quicktype)" },
        { "<leader>gb", function() require("modules.git-branch-selector").GitBranchSelector() end, desc = "Git branch picker" },
        { "<leader>P",  function() require("telescope.builtin").commands() end,                    desc = "Command Palette" },
        { "<leader>f",  function() require("telescope.builtin").treesitter() end,                  desc = "Símbolos (Treesitter) en buffer" },
        {
            "<leader>i",
            function()
                require("telescope").extensions.emoji.emoji({
                    attach_mappings = function(prompt_bufnr, map)
                        local function emoji_insert()
                            local selection = require("telescope.actions.state").get_selected_entry()
                            require("telescope.actions").close(prompt_bufnr)
                            if selection and selection.value then
                                vim.fn.setreg("*", selection.value)
                                vim.fn.setreg("+", selection.value)
                                vim.api.nvim_feedkeys('"*p', "n", false)
                            end
                        end
                        map("i", "<CR>", emoji_insert)
                        map("n", "<CR>", emoji_insert)
                        return true
                    end,
                })
            end,
            desc = "Elegir emoji",
        },
        { "<leader>b", function() require("modules.telescope_toggles").toggle_buffers() end,    desc = "Toggle Buffers" },
        { "<leader>m", function() require("modules.telescope_toggles").toggle_treesitter() end, desc = "Toggle Símbolos (treesitter)" },
    },

    config = function()
        local telescope = require("telescope")
        local actions = require("telescope.actions")
        local transform_mod = require("telescope.actions.mt").transform_mod
        local devicons = require("nvim-web-devicons")
        local trouble = require("trouble")
        local trouble_telescope = require("trouble.sources.telescope")

        local custom_actions = transform_mod({
            open_trouble_qflist = function(_) trouble.toggle("quickfix") end,
        })

        telescope.setup({
            defaults = {
                -- Ignorados típicos para monorepos
                file_ignore_patterns = {
                    "%.git/", "node_modules/", "dist/", "build/", "target/", "%.next/", "out/",
                    ".venv/", "vendor/", "__pycache__/", "coverage/", "%.cache/", "bin/", "obj/",
                },
                follow = true,
                sorting_strategy = "ascending",
                layout_strategy = "horizontal",
                layout_config = { horizontal = { width = 0.9 } },
                path_display = { "smart" },

                -- 🔧 Asegurá sorters funcionales incluso sin fzf
                file_sorter = require("telescope.sorters").get_fuzzy_file,
                generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,

                mappings = {
                    i = {
                        ["<C-k>"] = actions.move_selection_previous,
                        ["<C-j>"] = actions.move_selection_next,
                        ["<C-q>"] = actions.send_selected_to_qflist + custom_actions.open_trouble_qflist,
                        ["<C-t>"] = trouble_telescope.open,
                    },
                },

                -- Para live_grep (no afecta find_files)
                vimgrep_arguments = (function()
                    local args = { "rg", "--color=never", "--no-heading", "--with-filename", "--line-number", "--column",
                        "--smart-case" }
                    if vim.fn.has("win32") == 1 then
                        table.insert(args, "--hidden")
                        table.insert(args, "--no-ignore-vcs")
                    end
                    return args
                end)(),
            },

            -- Pickers con defaults sanos
            pickers = {
                find_files = {
                    initial_mode = "insert",
                    follow = true,
                    hidden = true,
                    no_ignore = true,
                },
                buffers = {
                    sort_mru = true,
                    ignore_current_buffer = true,
                    previewer = false,
                    initial_mode = "normal",
                    layout_config = { width = 0.5, height = 0.7 },
                    mappings = {
                        i = { ["<c-d>"] = require("telescope.actions").delete_buffer },
                        n = { ["<c-d>"] = require("telescope.actions").delete_buffer },
                    },
                    entry_maker = function(entry)
                        local bufname = vim.api.nvim_buf_get_name(entry.bufnr)
                        local basename = vim.fn.fnamemodify(bufname, ":t")
                        local icon, icon_hl = devicons.get_icon(basename, nil, { default = true })
                        local is_modified = vim.api.nvim_buf_get_option(entry.bufnr, "modified")
                        local modified = is_modified and " [+]" or ""
                        local smart_path = require("telescope.utils").transform_path({ path_display = { "smart" } },
                            bufname)
                        return {
                            value = entry,
                            display = function() return string.format(" %s  %s%s", icon, smart_path, modified) end,
                            ordinal = smart_path .. modified,
                            bufnr = entry.bufnr,
                            icon = icon,
                            icon_hl_group = icon_hl,
                        }
                    end,
                },
                treesitter = { initial_mode = "normal" },
                lsp_definitions = { initial_mode = "normal" },
                lsp_type_definitions = { initial_mode = "normal" },
                lsp_references = { initial_mode = "normal" },
                lsp_implementations = { initial_mode = "normal" },
            },

            -- ✅ FZF configurado para overridear sorters (si está compilado)
            extensions = {
                fzf = {
                    fuzzy = true,
                    case_mode = "smart_case",
                    override_generic_sorter = true,
                    override_file_sorter = true,
                },
            },
        })

        -- Cargar extensiones de forma segura
        pcall(telescope.load_extension, "fzf")
        pcall(telescope.load_extension, "emoji")

        -- Comando para quicktype + paste (si tu módulo existe)
        vim.api.nvim_create_user_command("PasteAsCode", function()
            require("modules.quicktype").setup()
            vim.cmd("PasteAsCode")
        end, {})
    end,
}
