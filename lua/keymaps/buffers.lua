-- ~/.config/nvim/lua/keymaps/buffers.lua

local M = {}

local last_valid_buf = nil
local prev_valid_buf = nil
local last_closed_buffer = nil

function M.setup()
    -- Autocmd para trackear el historial de buffers
    vim.api.nvim_create_autocmd("BufEnter", {
        callback = function(args)
            local bufnr = args.buf
            local ft = vim.bo[bufnr].filetype
            local bt = vim.bo[bufnr].buftype

            if ft ~= "NvimTree" and bt ~= "terminal" and vim.api.nvim_buf_is_valid(bufnr) then
                if bufnr ~= last_valid_buf then
                    prev_valid_buf = last_valid_buf
                    last_valid_buf = bufnr
                end
            end
        end,
    })

    vim.keymap.set("n", "<leader>W", function()
        local current_buf = vim.api.nvim_get_current_buf()
        local bufs = vim.fn.getbufinfo({ buflisted = 1 })

        for _, buf in ipairs(bufs) do
            local bt = vim.bo[buf.bufnr].buftype
            local ft = vim.bo[buf.bufnr].filetype

            if bt ~= "terminal" and ft ~= "NvimTree" and buf.bufnr ~= current_buf then
                vim.cmd("bdelete " .. buf.bufnr)
            end
        end

        -- Cerrar el buffer actual al final (si no es terminal/tree)
        local bt = vim.bo[current_buf].buftype
        local ft = vim.bo[current_buf].filetype
        if bt ~= "terminal" and ft ~= "NvimTree" then
            vim.cmd("bdelete " .. current_buf)
        end
    end, { desc = "Cerrar todos los buffers (menos terminal/NvimTree)" })

    -- Navegación entre buffers estilo tabs
    vim.keymap.set("n", "<Tab>", "<cmd>BufferLineCycleNext<CR>", { desc = "Next buffer" })
    vim.keymap.set("n", "<S-Tab>", "<cmd>BufferLineCyclePrev<CR>", { desc = "Previous buffer" })

    -- Restaurar último buffer cerrado
    vim.keymap.set("n", "<leader>T", function()
        if last_closed_buffer and vim.fn.filereadable(last_closed_buffer) == 1 then
            vim.cmd("edit " .. vim.fn.fnameescape(last_closed_buffer))
        else
            vim.notify("No hay buffer reciente para restaurar", vim.log.levels.WARN)
        end
    end, { desc = "Reabrir último buffer cerrado" })

    -- Cerrar buffer inteligentemente
    vim.keymap.set("n", "<leader>w", function()
        local current_buf = vim.api.nvim_get_current_buf()
        local current_name = vim.api.nvim_buf_get_name(current_buf)

        if current_name and current_name ~= "" then
            last_closed_buffer = current_name
        end

        if vim.bo.modified then
            vim.cmd("write")
        end

        if vim.bo.buftype == "terminal" then
            vim.cmd("bdelete!")
        else
            vim.cmd("bdelete")
        end

        -- Saltar al buffer anterior válido
        if prev_valid_buf and vim.api.nvim_buf_is_valid(prev_valid_buf) then
            vim.api.nvim_set_current_buf(prev_valid_buf)
        end
    end, { desc = "Smart close buffer" })

    -- Reordenar buffers
    vim.keymap.set("n", "<Leader><Right>", "<cmd>BufferLineMoveNext<CR>", { desc = "Move buffer right" })
    vim.keymap.set("n", "<Leader><Left>", "<cmd>BufferLineMovePrev<CR>", { desc = "Move buffer left" })
end

return M
