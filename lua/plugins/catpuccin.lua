-- ~/.config/nvim/lua/plugins/catppuccin.lua
return {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
        require("catppuccin").setup({
            flavour = "mocha",
            transparent_background = false,
            show_end_of_buffer = false,
            term_colors = false,
            no_italic = false,
            no_bold = false,
            styles = {
                comments = { "italic" },
                conditionals = {},
                loops = {},
                functions = {},
                keywords = {},
                strings = {},
                variables = {},
                numbers = {},
                booleans = {},
                properties = {},
                types = {},
                operators = {},
            },
            integrations = {
                cmp = true,
                gitsigns = true,
                nvimtree = true,
                telescope = true,
                treesitter = true,
                notify = false,
                mini = false,
            },
            color_overrides = {
                mocha = {
                    base = "#000000",
                    mantle = "#000000",
                    crust = "#000000",
                },
            },
            custom_highlights = function(colors)
                local orange = "#FBA834"
                local light_orange = "#ffcd81"
                local violet = "#9a64ff"
                local light_violet = "#bb9af7"
                local white = "#ffffff"
                local light_blue = "#B2D8CE"
                local sand = "#FFF1D5"
                local telescopeBorder = "#0E2148"

                -- Gradiente suave diagonal: naranja (top-left) -> violeta (bottom-right)
                -- Evitando rosas, usando transición: naranja -> dorado -> cobre -> púrpura cálido -> violeta
                local gradient = {
                    orange_start = "#FBA834",      -- Inicio: naranja puro (top-left)
                    orange_warm = "#FF9F4A",       -- Naranja cálido
                    golden = "#FFB366",            -- Dorado
                    amber = "#E8A86B",             -- Ámbar
                    copper = "#C99883",            -- Cobre (evita rosa)
                    warm_purple = "#B088A0",       -- Púrpura cálido
                    purple_blue = "#A276D8",       -- Violeta azulado
                    violet_end = "#9a64ff",        -- Fin: violeta puro (bottom-right)
                }

                -- Aplicar gradiente a diferentes secciones de Telescope
                -- PromptBorder (arriba): dominan naranjas y dorados
                vim.api.nvim_set_hl(0, "TelescopePromptBorder", { fg = gradient.orange_start })
                vim.api.nvim_set_hl(0, "TelescopePromptPrefix", { fg = gradient.orange_warm })

                -- ResultsBorder (medio): más violeta, menos rosa
                vim.api.nvim_set_hl(0, "TelescopeResultsBorder", { fg = gradient.purple_blue })

                -- PreviewBorder (abajo): dominan púrpuras y violetas
                vim.api.nvim_set_hl(0, "TelescopePreviewBorder", { fg = gradient.violet_end })

                -- Bordes generales
                vim.api.nvim_set_hl(0, "TelescopeBorder", { fg = gradient.purple_blue })
                vim.api.nvim_set_hl(0, "FloatBorder", { fg = telescopeBorder })

                -- Títulos con gradiente
                vim.api.nvim_set_hl(0, "TelescopePromptTitle", { fg = gradient.orange_start, bold = true })
                vim.api.nvim_set_hl(0, "TelescopeResultsTitle", { fg = gradient.amber, bold = true })
                vim.api.nvim_set_hl(0, "TelescopePreviewTitle", { fg = gradient.purple_blue, bold = true })
                vim.api.nvim_set_hl(0, "TelescopeTitle", { fg = orange })
                vim.api.nvim_set_hl(0, "FloatTitle", { fg = orange })

                -- Selección con color del gradiente
                vim.api.nvim_set_hl(0, "TelescopeSelection", { fg = white, bg = "#1a1a1a", bold = true })
                vim.api.nvim_set_hl(0, "TelescopeSelectionCaret", { fg = gradient.orange_warm, bg = "#1a1a1a" })
                vim.api.nvim_set_hl(0, "TelescopeMatching", { fg = gradient.golden, bold = true })

                vim.api.nvim_set_hl(0, "TelescopeNormal", { fg = white })

                return {
                    -- Fondo y texto general
                    Normal = { fg = white, bg = "#000000" },
                    Cursor = { fg = "#000000", bg = white },

                    -- Selección y referencias
                    Visual = { bg = "#404040" },
                    LspReferenceText = { bg = "#303030" },
                    LspReferenceRead = { bg = "#303030" },
                    LspReferenceWrite = { bg = "#303030" },

                    -- Semánticos LSP
                    LspSemanticVariable = { fg = white },
                    LspSemanticParameter = { fg = white },
                    LspSemanticProperty = { fg = light_orange },
                    LspSemanticMethod = { fg = "#ffb34f" },
                    LspSemanticFunction = { fg = orange },
                    LspSemanticClass = { fg = "#2eb2bb" },
                    LspSemanticType = { fg = "#75bcff" },

                    -- Tokens básicos
                    Comment = { fg = "#7f8c8d", italic = true },
                    String = { fg = "#fffdca" },
                    Keyword = { fg = violet },
                    Number = { fg = "#F78C6C" },
                    Operator = { fg = violet },
                    Function = { fg = orange },
                    Variable = { fg = white },
                    Type = { fg = light_blue },
                    Constant = { fg = sand },

                    -- Tabs
                    TabLine = { fg = white, bg = "#000000" },
                    TabLineSel = { fg = white, bg = "#000000", underline = true },
                    TabLineFill = { bg = "#000000" },

                    -- NvimTree
                    NvimTreeNormal = { fg = white, bg = "#000000" },
                    NvimTreeCursorLine = { bg = "#111111" },

                    -- TypeScript / JSX específico
                    Include = { fg = violet, italic = true },
                    Conditional = { fg = violet, italic = true },
                    ["@keyword.export"] = { fg = violet, italic = true },
                    ["@keyword.return"] = { fg = violet, italic = true },
                    ["@operator"] = { fg = violet },
                    ["@parameter"] = { fg = white },
                    ["@type"] = { fg = light_blue },

                    -- JSX (React)
                    ["@type.tsx"] = { fg = light_orange }, -- <Component>
                    ["@tag.builtin.tsx"] = { fg = "#73ffc5" }, -- HTML: <div>
                    ["@tag.tsx"] = { fg = light_orange }, -- <>
                    ["@variable"] = { fg = white },
                    ["@variable.builtin"] = { fg = white },
                    ["@variable.parameter"] = { fg = white },
                    ["@lsp.type.variable.typescript"] = { fg = white },
                    ["@lsp.type.parameter.typescript"] = { fg = white },

                    -- Properties
                    ["@variable.member"] = { fg = light_orange },
                    ["@lsp.type.property.typescript"] = { fg = light_orange },
                    ["@lsp.type.member"] = { fg = light_orange }, -- opcional
                    ["@property"] = { fg = light_orange }, -- fallback común

                    -- Attributes
                    ["@_jsx_attribute.tsx"] = { fg = violet, italic = false },
                    ["@tag.attribute.tsx"] = { fg = violet, italic = false },

                    -- Exceptions
                    Exception = { fg = violet },
                }
            end,
        })
        vim.cmd.colorscheme("catppuccin")
    end,
}
