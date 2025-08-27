local M = {}

-- Variables para trackear pickers abiertos
local current_buffers_picker = nil
local current_treesitter_picker = nil

-- Toggle function para buffers
function M.toggle_buffers()
    if current_buffers_picker then
        require("telescope.actions").close(current_buffers_picker.prompt_bufnr)
        current_buffers_picker = nil
        return
    end

    require("telescope.builtin").buffers({
        attach_mappings = function(prompt_bufnr, map)
            current_buffers_picker = { prompt_bufnr = prompt_bufnr }

            -- Hook para limpiar cuando el picker se cierre
            vim.api.nvim_buf_attach(prompt_bufnr, false, {
                on_detach = function()
                    current_buffers_picker = nil
                end,
            })

            return true
        end,
    })
end

-- Toggle function para treesitter
function M.toggle_treesitter()
    if current_treesitter_picker then
        require("telescope.actions").close(current_treesitter_picker.prompt_bufnr)
        current_treesitter_picker = nil
        return
    end

    require("telescope.builtin").treesitter({
        attach_mappings = function(prompt_bufnr, map)
            current_treesitter_picker = { prompt_bufnr = prompt_bufnr }

            -- Hook para limpiar cuando el picker se cierre
            vim.api.nvim_buf_attach(prompt_bufnr, false, {
                on_detach = function()
                    current_treesitter_picker = nil
                end,
            })

            return true
        end,
    })
end

return M