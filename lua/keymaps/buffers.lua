-- ~/.config/nvim/lua/keymaps/buffers.lua

local M = {}

function M.setup()
    -- Navegación entre buffers estilo tabs
    vim.keymap.set("n", "<Tab>", "<cmd>BufferLineCycleNext<CR>", { desc = "Next buffer" })
    vim.keymap.set("n", "<S-Tab>", "<cmd>BufferLineCyclePrev<CR>", { desc = "Previous buffer" })

    -- Cerrar buffer
    vim.keymap.set("n", "<leader>w", function()
        local current_buf = vim.api.nvim_get_current_buf()

        -- Guardar antes de cerrar
        if vim.bo.modified then
            vim.cmd("write")
        end

        -- Cierra el buffer actual
        -- Detecta si es un terminal y fuerza el cierre
        if vim.bo.buftype == "terminal" then
            vim.cmd("bdelete!") -- Forzar si es terminal
        else
            vim.cmd("bdelete") -- Normal si no lo es
        end

        -- Si nvim-tree quedó enfocado, salta al buffer anterior
        if vim.bo.filetype == "NvimTree" then
            -- Intentamos ir al buffer anterior
            local bufs = vim.fn.getbufinfo({ buflisted = 1 })
            for _, buf in ipairs(bufs) do
                if buf.bufnr ~= current_buf then
                    vim.api.nvim_set_current_buf(buf.bufnr)
                    return
                end
            end
        end
    end, { desc = "Smart close buffer" })

    -- Reordenar buffers
    vim.keymap.set("n", "<Leader><Right>", "<cmd>BufferLineMoveNext<CR>", { desc = "Move buffer right" })
    vim.keymap.set("n", "<Leader><Left>", "<cmd>BufferLineMovePrev<CR>", { desc = "Move buffer left" })
end

return M
