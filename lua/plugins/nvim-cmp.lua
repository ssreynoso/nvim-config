return {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
        "hrsh7th/cmp-buffer", -- source para texto en el buffer actual
        "hrsh7th/cmp-path", -- source para paths del sistema de archivos
        {
            "L3MON4D3/LuaSnip",
            version = "v2.*", -- última versión estable
            build = "make install_jsregexp", -- opcional para mejor compatibilidad con regex
        },
        "saadparwaiz1/cmp_luasnip", -- integración entre cmp y LuaSnip
        "onsails/lspkind.nvim", -- íconos tipo VS Code
    },
    config = function()
        local cmp = require("cmp")
        local luasnip = require("luasnip")
        local lspkind = require("lspkind")

        cmp.setup({
            completion = {
                completeopt = "menu,menuone,preview,noselect",
            },
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ["<C-k>"] = cmp.mapping.select_prev_item(),
                ["<C-j>"] = cmp.mapping.select_next_item(),
                ["<C-d>"] = cmp.mapping.scroll_docs(-4),
                ["<C-u>"] = cmp.mapping.scroll_docs(4),
                ["<C-Space>"] = cmp.mapping.complete(),
                ["<C-e>"] = cmp.mapping.abort(),
                ["<CR>"] = cmp.mapping.confirm({ select = true }),
            }),
            sources = cmp.config.sources({
                { name = "nvim_lsp" },
                { name = "luasnip" },
                { name = "buffer", keyword_length = 3, max_item_count = 5 },
                { name = "path" },
            }),
            formatting = {
                format = lspkind.cmp_format({ maxwidth = 50 }),
            },
        })
    end,
}
