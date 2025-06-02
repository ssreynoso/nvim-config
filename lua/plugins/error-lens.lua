
return {
	"chikko80/error-lens.nvim",
	event = "BufRead",
	dependencies = {
		"nvim-telescope/telescope.nvim",
	},
	config = function()
		require("error-lens").setup({
			-- Podés personalizar colores, símbolos, severidades...
			-- Pero esta config base ya es parecida a VSCode
		})
	end,
}
