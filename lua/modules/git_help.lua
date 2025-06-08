local M = {}

function M.open_git_help()
    local lines = {
        "🌿 Git Keymaps",
        "",
        "🧠 Conflictos:",
        "  <leader>gc   → Lista de conflictos (Quickfix)",
        "",
        "📄 Diffview:",
        "  <leader>gd   → Diff del archivo actual",
        "  <leader>gD   → Diff completo del proyecto",
        "  <leader>gh   → Toggle historial del archivo actual",
        "",
        "🌲 Worktrees:",
        "  <leader>gw   → Ver worktrees",
        "  <leader>gW   → Crear nueva worktree",
        "  <leader>gwd  → Eliminar worktree",
    }

    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

    local width = 50
    local height = #lines + 2
    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)

    vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = width,
        height = height,
        row = row,
        col = col,
        style = "minimal",
        border = "rounded",
    })
end

return M
