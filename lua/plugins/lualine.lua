return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        local colors = {
            orange = "#FBA834",
            light_orange = "#ffcd81",
            violet = "#9a64ff",
            light_violet = "#bb9af7",
            white = "#ffffff",
            light_blue = "#B2D8CE",
            sand = "#FFF1D5",
            bg = "#000000", -- fondo negro total
        }

        local theme = {
            normal = {
                a = { fg = colors.bg, bg = colors.light_orange, gui = "bold" },
                b = { fg = colors.light_orange, bg = colors.bg },
                c = { fg = colors.white, bg = colors.bg },
            },
            insert = {
                a = { fg = colors.bg, bg = colors.light_violet, gui = "bold" },
                b = { fg = colors.light_violet, bg = colors.bg },
                c = { fg = colors.white, bg = colors.bg },
            },
            visual = {
                a = { fg = colors.bg, bg = colors.orange, gui = "bold" },
                b = { fg = colors.orange, bg = colors.bg },
                c = { fg = colors.white, bg = colors.bg },
            },
            replace = {
                a = { fg = colors.bg, bg = colors.violet, gui = "bold" },
                b = { fg = colors.violet, bg = colors.bg },
                c = { fg = colors.white, bg = colors.bg },
            },
            inactive = {
                a = { fg = colors.light_blue, bg = colors.bg, gui = "bold" },
                b = { fg = colors.light_blue, bg = colors.bg },
                c = { fg = colors.light_blue, bg = colors.bg },
            },
        }

        require("lualine").setup({
            options = {
                theme = theme,
                icons_enabled = true,
                -- section_separators = "", -- sin flechitas
                -- component_separators = "", -- sin barras
                globalstatus = true, -- una sola barra abajo
            },
            sections = {
                lualine_a = { "mode" },
                lualine_b = { "branch", "diff", "diagnostics" },
                lualine_c = {
                    {
                        function()
                            local path = vim.fn.expand("%:p")
                            local formatted = vim.fn.fnamemodify(path, ":~:.") -- relativo
                            formatted = formatted:gsub("\\", "/") -- reemplazar '\' por '/'
                            return formatted
                        end,
                    },
                },
                lualine_x = { "encoding", "fileformat", "filetype" },
                lualine_y = { "progress" },
                lualine_z = {
                    "location",
                    function()
                        return os.date("%H:%M")
                    end,
                },
            },
        })
    end,
}
