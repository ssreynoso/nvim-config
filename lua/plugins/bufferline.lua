return {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    init = function()
        require("keymaps.buffers").setup()
    end,
    config = function()
        require("bufferline").setup({
            options = {
                mode = "buffers", -- cada buffer como una tab (no tabs reales)
                show_buffer_close_icons = true,
                show_close_icon = false,
                diagnostics = "nvim_lsp", -- muestra errores si usás LSP
                separator_style = "padded_slant", -- o "thick", "thin", "padded_slant"
                always_show_bufferline = true,
                offsets = {
                    {
                        filetype = "NvimTree",
                        text = "File Explorer",
                        text_align = "center",
                        separator = true,
                    },
                },
                custom_filter = function(bufnr)
                    local ok_note, is_note = pcall(function()
                        return vim.api.nvim_buf_get_var(bufnr, "floater_note")
                    end)
                    local ok_term, is_term = pcall(function()
                        return vim.api.nvim_buf_get_var(bufnr, "floater_terminal")
                    end)
                    return not (ok_note and is_note) and not (ok_term and is_term)
                end,
            },
        })
    end,
}
