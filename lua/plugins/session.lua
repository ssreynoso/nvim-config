return {
    "folke/persistence.nvim",
    event = "BufReadPre", -- this will only start session saving when an actual file was opened
    opts = {
        -- add any custom options here
    },
    config = function(_, opts)
        local persistence = require("persistence")

        persistence.setup(opts)

        -- Automatically save the session when exiting Neovim
        vim.api.nvim_create_autocmd("VimLeavePre", {
            callback = function()
                require("persistence").save()
            end,
        })

        vim.keymap.set("n", "<leader>qs", function()
            persistence.select()
        end, { desc = "Seleccionar sesión" })

        vim.keymap.set("n", "<leader>ql", function()
            persistence.load({ last = true })
        end, { desc = "Cargar última sesión" })

        vim.keymap.set("n", "<leader>qd", function()
            persistence.stop()
        end, { desc = "Desactivar guardado de sesión" })
    end,
}
