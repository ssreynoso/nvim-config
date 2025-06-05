-- ~/.config/nvim/lua/modules/loader.lua

local M = {}

local state = {
    win = nil,
    buf = nil,
}

function M.show_loader(message)
    message = message or " Loading..."

    local buf = vim.api.nvim_create_buf(false, true)
    local width = #message + 4
    local height = 1
    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)

    local win = vim.api.nvim_open_win(buf, false, {
        relative = "editor",
        width = width,
        height = height,
        row = row,
        col = col,
        style = "minimal",
        border = "rounded",
    })

    vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "  " .. message .. "  " })
    state.win = win
    state.buf = buf

    return M.hide_loader
end

function M.hide_loader()
    if state.win and vim.api.nvim_win_is_valid(state.win) then
        vim.api.nvim_win_close(state.win, true)
        state.win = nil
    end
    if state.buf and vim.api.nvim_buf_is_valid(state.buf) then
        vim.api.nvim_buf_delete(state.buf, { force = true })
        state.buf = nil
    end
end

return M
