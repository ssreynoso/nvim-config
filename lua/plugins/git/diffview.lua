return {
    {
        "sindrets/diffview.nvim",
        cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose" },
        dependencies = { "nvim-lua/plenary.nvim" },
        keys = {
            {
                "<leader>gd",
                function()
                    local file = vim.fn.expand("%")
                    vim.cmd("DiffviewOpen HEAD -- " .. file)
                end,
                desc = "Diff del archivo actual contra HEAD",
            },
            {
                "<leader>gD",
                "<cmd>DiffviewOpen<CR>",
                desc = "Ver diff del proyecto",
            },
            {
                "<leader>gh",
                function()
                    local view = require("diffview.lib").get_current_view()
                    if view then
                        vim.cmd("DiffviewClose")
                    else
                        vim.cmd("DiffviewFileHistory %")
                    end
                end,
                desc = "Toggle historial del archivo actual",
            },
        },
    },
}
