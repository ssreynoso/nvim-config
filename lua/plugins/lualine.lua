-- ~/.config/nvim/lua/plugins/lualine.lua
return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" }, -- para íconos
    config = function()
        require("lualine").setup({
        })
    end,
}
