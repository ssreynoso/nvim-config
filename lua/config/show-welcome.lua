vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        require("modules.welcome").show()
    end,
})
