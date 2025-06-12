local M = {}

function M.close_non_file_buffers()
    local buffers = vim.api.nvim_list_bufs()

    for _, buf in ipairs(buffers) do
        if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_is_loaded(buf) then
            local bt = vim.bo[buf].buftype
            local ft = vim.bo[buf].filetype

            local is_file = bt == "" and ft ~= "NvimTree"

            if not is_file then
                vim.cmd("bdelete! " .. buf)
            end
        end
    end
end

return M
