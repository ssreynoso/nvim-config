vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        require("modules.welcome").show(function()
            vim.schedule(function()
                require("modules.select-with-callback").select_with_callback(function()
                    local group = vim.api.nvim_create_augroup("CloseNonFilesOnce", { clear = true })

                    vim.api.nvim_create_autocmd("BufEnter", {
                        group = group,
                        once = true,
                        callback = function()
                            require("modules.close-non-file-buffers").close_non_file_buffers()
                        end,
                    })
                end)
            end)
        end)
    end,
})
