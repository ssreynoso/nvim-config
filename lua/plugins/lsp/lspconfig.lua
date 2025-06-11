return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        { "antosha417/nvim-lsp-file-operations", config = true },
        { "folke/neodev.nvim", opts = {} },
    },
    config = function()
        require("neodev").setup()

        local keymap = vim.keymap

        local action_state = require("telescope.actions.state")

        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("UserLspConfig", {}),
            callback = function(ev)
                local opts = { buffer = ev.buf, silent = true }

                opts.desc = "Show LSP references"
                keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)

                opts.desc = "Go to declaration"
                keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

                opts.desc = "Show LSP definitions"
                keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)

                opts.desc = "Show LSP implementations"
                keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

                opts.desc = "Show LSP type definitions"
                keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

                opts.desc = "See available code actions"
                keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

                opts.desc = "Smart rename"
                keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

                opts.desc = "Show buffer diagnostics"
                keymap.set("n", "<leader>D", function()
                    local previewers = require("telescope.previewers")

                    require("telescope.builtin").diagnostics({
                        bufnr = 0,
                        layout_strategy = "horizontal",
                        layout_config = {
                            width = 0.8,
                            height = 0.7,
                            preview_width = 0.6,
                        },
                        previewer = previewers.new_buffer_previewer({
                            define_preview = function(self, entry, _)
                                local bufnr = entry.bufnr
                                local lnum = entry.lnum or 0
                                local filename = entry.filename or vim.api.nvim_buf_get_name(bufnr)
                                local lines = {}

                                local context_lines = 7
                                local ok, file_lines = pcall(vim.fn.readfile, filename)
                                local start_line = 0
                                if ok and file_lines then
                                    start_line = math.max(lnum - context_lines, 0)
                                    local end_line = math.min(lnum + context_lines, #file_lines - 1)
                                    for i = start_line + 1, end_line + 1 do
                                        table.insert(lines, file_lines[i] or "")
                                    end
                                else
                                    table.insert(lines, "[No se pudo leer el archivo]")
                                end

                                table.insert(lines, "")
                                table.insert(lines, string.rep("─", 50))
                                table.insert(lines, "")

                                local msg = entry.text or "Sin mensaje"
                                local severity = entry.type or "Desconocido"
                                local severity_colors = {
                                    ERROR = "DiagnosticError",
                                    WARN = "DiagnosticWarn",
                                    INFO = "DiagnosticInfo",
                                    HINT = "DiagnosticHint",
                                }

                                local function wrap_text(text, width)
                                    local wrapped = {}
                                    while #text > width do
                                        local space = text:sub(1, width):match(".*()%s")
                                        local break_point = space or width
                                        table.insert(wrapped, text:sub(1, break_point))
                                        text = text:sub(break_point + 1)
                                    end
                                    table.insert(wrapped, text)
                                    return wrapped
                                end

                                local msg_lines = wrap_text("󰎡 " .. severity .. ": " .. msg, 80)
                                local msg_line_index = #lines + 1
                                vim.list_extend(lines, msg_lines)

                                local win_height = math.floor(vim.o.lines * 0.6 * 0.95)
                                while #lines < win_height do
                                    table.insert(lines, "")
                                end

                                vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, lines)
                                vim.api.nvim_buf_set_option(self.state.bufnr, "filetype", "lua")

                                local hl = severity_colors[severity]
                                if hl then
                                    for i = 0, #msg_lines - 1 do
                                        vim.api.nvim_buf_add_highlight(
                                            self.state.bufnr,
                                            -1,
                                            hl,
                                            msg_line_index - 1 + i,
                                            0,
                                            -1
                                        )
                                    end
                                end

                                local highlight_line = (lnum - start_line) - 1
                                if highlight_line >= 0 and highlight_line < #lines then
                                    vim.api.nvim_buf_add_highlight(
                                        self.state.bufnr,
                                        -1,
                                        "Visual",
                                        highlight_line,
                                        0,
                                        -1
                                    )
                                end
                            end,
                        }),
                        attach_mappings = function(prompt_bufnr, map)
                            local actions = require("telescope.actions")
                            local action_state = require("telescope.actions.state")

                            map("n", "y", function()
                                local picker = action_state.get_current_picker(prompt_bufnr)
                                local selections = picker:get_multi_selection()

                                local entries = {}
                                if vim.tbl_isempty(selections) then
                                    local entry = action_state.get_selected_entry()
                                    if entry then
                                        table.insert(entries, entry)
                                    end
                                else
                                    entries = selections
                                end

                                local lines = {}
                                for _, entry in ipairs(entries) do
                                    local msg = entry.text or "Sin mensaje"
                                    local severity = entry.type or "Desconocido"
                                    local filename = entry.filename or vim.api.nvim_buf_get_name(entry.bufnr)
                                    local lnum = entry.lnum or 0
                                    table.insert(
                                        lines,
                                        string.format("[%s] %s:%d\n%s\n", severity, filename, lnum, msg)
                                    )
                                end

                                local final_text = table.concat(lines, "\n")
                                vim.fn.setreg("+", final_text)
                                local count = #entries
                                local label = count == 1 and "diagnostic" or "diagnostics"
                                vim.notify(
                                    string.format("%d %s copied to clipboard.", count, label),
                                    vim.log.levels.INFO
                                )
                            end)

                            return true
                        end,
                    })
                end, opts)

                opts.desc = "Go to previous diagnostic"
                keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)

                opts.desc = "Go to next diagnostic"
                keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

                opts.desc = "Show documentation for what is under cursor"
                keymap.set("n", "K", vim.lsp.buf.hover, opts)

                opts.desc = "Restart LSP"
                keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)

                opts.desc = "Show LSP Info"
                keymap.set("n", "<leader>si", ":LspInfo<CR>", opts)
            end,
        })

        local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
        for type, icon in pairs(signs) do
            local hl = "DiagnosticSign" .. type
            vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
        end

        -- 🔧 Mover setup_handlers acá
        local lspconfig = require("lspconfig")
        local cmp_nvim_lsp = require("cmp_nvim_lsp")
        local capabilities = cmp_nvim_lsp.default_capabilities()

        require("mason-lspconfig").setup_handlers({
            function(server_name)
                lspconfig[server_name].setup({
                    capabilities = capabilities,
                })
            end,
            ["jsonls"] = function()
                lspconfig.jsonls.setup({
                    capabilities = capabilities,
                    settings = {
                        json = {
                            format = { enable = false },
                            validate = { enable = true },
                        },
                    },
                })
            end,
            ["lua_ls"] = function()
                lspconfig.lua_ls.setup({
                    capabilities = capabilities,
                    settings = {
                        Lua = {
                            diagnostics = { globals = { "vim" } },
                            completion = { callSnippet = "Replace" },
                        },
                    },
                })
            end,
            ["graphql"] = function()
                lspconfig.graphql.setup({
                    capabilities = capabilities,
                    filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
                })
            end,
            ["emmet_ls"] = function()
                lspconfig.emmet_ls.setup({
                    capabilities = capabilities,
                    filetypes = {
                        "html",
                        "typescriptreact",
                        "javascriptreact",
                        "css",
                        "sass",
                        "scss",
                        "less",
                        "svelte",
                    },
                })
            end,
        })
    end,
}
