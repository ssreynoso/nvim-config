return {
    {
        "karb94/neoscroll.nvim",
        opts = {
            duration_multiplier = 0.1,
            easing = "quintic",
        },
    },
    {
        "sphamba/smear-cursor.nvim",
        opts = {
            -- Opcionales, podés ajustar estos valores a tu gusto
            highlight_group = "Cursor", -- o 'IncSearch', 'Visual', etc.
            min_distance = 3, -- distancia mínima para generar estela
            speed = 25, -- velocidad de desvanecimiento
            smear_insert_mode = true,
            smear_between_buffers = true,
            smear_between_neighbor_lines = true,
        },
    },
}
