vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        require("modules.welcome").show(function()
            vim.schedule(function()
                require("modules.select-with-callback").select_with_callback(function()
                    vim.cmd("NvimTreeToggle")
                end)
            end)
        end)
    end,
})
