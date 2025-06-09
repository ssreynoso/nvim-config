return {
    "NeogitOrg/neogit",
    cmd = "Neogit",
    keys = {
        { "<leader>gs", "<cmd>Neogit<CR>", desc = "Abrir Neogit" },
        {
            "<leader>gh",
            function()
                local file = vim.fn.expand("%:p")
                if file == "" or vim.fn.filereadable(file) == 0 then
                    vim.notify("Archivo inválido para mostrar historial", vim.log.levels.WARN)
                    return
                end

                local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
                if not git_root or git_root == "" then
                    vim.notify("No estás en un repositorio Git", vim.log.levels.ERROR)
                    return
                end

                vim.cmd("lcd " .. git_root)
                vim.cmd("DiffviewFileHistory " .. file)
            end,
            desc = "Historial del archivo actual (Diffview)",
        },
    },
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
        {
            "sindrets/diffview.nvim",
            config = true,
        },
    },
    config = function()
        require("neogit").setup({
            kind = "tab", -- o "split", "floating"
            integrations = {
                telescope = true,
                diffview = true,
            },
        })

        vim.api.nvim_create_autocmd("FileType", {
            pattern = { "DiffviewFiles", "DiffviewFileHistory", "DiffviewFilePanel", "DiffviewView" },
            callback = function()
                vim.keymap.set("n", "<C-x>", "<cmd>DiffviewClose<CR>", { buffer = true, desc = "Cerrar Diffview" })
                vim.keymap.set("n", "<C-e>", "<cmd>DiffviewToggleFiles<CR>", {
                    buffer = true,
                    desc = "Toggle file panel in Diffview",
                })
            end,
        })
    end,
}
