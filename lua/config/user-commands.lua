vim.api.nvim_create_user_command("CopyDiagnostics", function()
    local diagnostics = vim.diagnostic.get(0)
    if #diagnostics == 0 then
        print("No hay diagnostics para copiar.")
        return
    end

    local lines = {}
    for _, d in ipairs(diagnostics) do
        local msg = string.format(
            "[%s] %s:%d:%d - %s",
            vim.diagnostic.severity[d.severity],
            vim.api.nvim_buf_get_name(0),
            d.lnum + 1,
            d.col + 1,
            d.message:gsub("\n", " ")
        )
        table.insert(lines, msg)
    end

    local text = table.concat(lines, "\n")
    vim.fn.setreg("+", text) -- Portapapeles (usa "*" si preferís selección primaria)
    print("Diagnostics copiados al portapapeles.")
end, {})

vim.keymap.set("n", "<leader>cd", ":CopyDiagnostics<CR>", { desc = "Copy document diagnostics" })

vim.keymap.set("n", "<leader>ar", function()
    -- Inserta el texto después del cursor
    vim.api.nvim_put({ "() => {}" }, "c", true, true)

    -- Posiciona el cursor en el medio de las llaves
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    vim.api.nvim_win_set_cursor(0, { row, col + 6 }) -- justo después de la apertura {

    -- Entra en modo insert
    vim.api.nvim_feedkeys("i", "n", false)
end, { desc = "Insert arrow function and enter insert mode" })
