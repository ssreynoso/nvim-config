return {
	"akinsho/bufferline.nvim",
	version = "*",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	init = function()
		require("keymaps.buffers").setup()
	end,
	config = function()
		require("bufferline").setup({
			options = {
				mode = "buffers",        -- cada buffer como una tab (no tabs reales)
				show_buffer_close_icons = true,
				show_close_icon = false,
				diagnostics = "nvim_lsp", -- muestra errores si usás LSP
				separator_style = "padded_slant", -- o "thick", "thin", "padded_slant"
				always_show_bufferline = true,
				offsets = {
					{
						filetype = "NvimTree",
						text = "File Explorer",
						text_align = "center",
						separator = true,
					},
				},
			},
		})
	end,
}
