return {
    --[[ {
        "karb94/neoscroll.nvim",
        config = function()
            local neoscroll = require("neoscroll")

            local easing = "sine"
            local zz_time_ms = 100
            local jump_time_ms = 200

            local centering_function = function()
                local defer_time_ms = 10
                vim.defer_fn(function()
                    neoscroll.zz(zz_time_ms, easing)
                end, defer_time_ms)
            end

            neoscroll.setup({
                duration_multiplier = 0.1,
                easing = easing,
                mappings = {}, -- desactiva mappings default
                post_hook = function(info)
                    if info == "center" then
                        centering_function()
                    end
                end,
            })

            local mappings = {
                ["<C-u>"] = { "scroll", { "-vim.wo.scroll", "true", jump_time_ms, easing, "'center'" } },
                ["<C-d>"] = { "scroll", { "vim.wo.scroll", "true", jump_time_ms, easing, "'center'" } },
            }

            require("neoscroll.config").set_mappings(mappings)
        end,
    } ]]
    {
        "sphamba/smear-cursor.nvim",
        event = "VeryLazy",
        opts = {
            highlight_group = "Cursor",
            min_distance = 4, -- menos ruido en movimientos chiquitos
            speed = 30,       -- se va un toque más rápido, más limpio
            smear_insert_mode = true,
            smear_between_buffers = true,
            smear_between_neighbor_lines = true,
        },
    }
}
