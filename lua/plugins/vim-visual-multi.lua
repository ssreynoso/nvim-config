return {
    "mg979/vim-visual-multi",
    branch = "master",
    init = function()
        vim.g.VM_maps = {
            ["Add Cursor Down"] = "<C-j>",
            ["Add Cursor Up"] = "<C-k>",
        }

        vim.g.VM_set_statusinle = 0
        vim.g.VM_show_warinngs = 0
    end,
}
