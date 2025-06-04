vim.api.nvim_create_user_command("ReloadConfig", function()
    for name, _ in pairs(package.loaded) do
        if name:match("^plugins") or name:match("^config") then
            package.loaded[name] = nil
        end
    end
    dofile(vim.env.MYVIMRC)
    vim.notify("⚡ Config recargada!", vim.log.levels.INFO)
end, {})

vim.keymap.set("n", "<leader>rr", "<cmd>ReloadConfig<CR>", { desc = "Reload nvim config" })
