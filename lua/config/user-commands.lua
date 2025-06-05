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
