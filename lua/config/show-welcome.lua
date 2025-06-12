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
                            vim.api.nvim_feedkeys(
                                vim.api.nvim_replace_termcodes("<leader>e", true, false, true),
                                "n",
                                false
                            )
                            -- vim.cmd("NvimTreeToggle")
                            -- require("modules.close-non-file-buffers").close_non_file_buffers()
                        end,
                    })
                end)
            end)
        end)
    end,
})
