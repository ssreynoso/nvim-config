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

-- Git help
vim.api.nvim_create_user_command("GitHelp", function()
    require("modules.git_help").open_git_help()
end, {})

-- Git Float Help
vim.api.nvim_create_user_command("FloatHelp", function(opts)
    local topic = opts.args
    if topic == "" then
        vim.notify("Especificá un tema de ayuda, por ejemplo: :FloatHelp nvim-tree.git.timeout", vim.log.levels.WARN)
        return
    end

    local floatter = require("modules.floatter")

    -- Guardamos las ventanas abiertas antes del help
    local wins_before = vim.api.nvim_list_wins()

    -- Ejecutamos el comando de ayuda
    vim.cmd("help " .. topic)

    -- Identificamos la nueva ventana de ayuda
    local wins_after = vim.api.nvim_list_wins()
    local help_win
    for _, win in ipairs(wins_after) do
        if not vim.tbl_contains(wins_before, win) then
            help_win = win
            break
        end
    end

    -- Si la encontramos, obtenemos su buffer y la cerramos
    if help_win then
        local help_buf = vim.api.nvim_win_get_buf(help_win)
        vim.api.nvim_win_close(help_win, true)

        -- Mostramos el buffer en una ventana flotante
        local float = floatter.create_floating_window({
            title = " Help: " .. topic,
            buf = help_buf,
        })
        floatter.state.help = float
    else
        vim.notify("No se pudo detectar la ventana de ayuda", vim.log.levels.ERROR)
    end
end, {
    nargs = 1,
    complete = "help",
    desc = "Abrir ayuda en una ventana flotante",
})

vim.keymap.set("n", "<leader>fh", function()
    vim.ui.input({ prompt = "Help topic:" }, function(input)
        if input then
            vim.cmd("FloatHelp " .. input)
        end
    end)
end, { desc = "Ayuda flotante" })
