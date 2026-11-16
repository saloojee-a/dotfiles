return {
	"nvim-lualine/lualine.nvim",

	dependencies = { "nvim-tree/nvim-web-devicons" },
	event = "VeryLazy",
	opts = {
		options = {
			theme = "auto",
			section_separators = { left = "\u{e0b4}", right = "\u{e0b6}" },
			component_separators = { left = "|", right = "|" },
		},
		sections = {
			lualine_a = {
				{ "mode", color = { gui = "bold" } },
			},
			lualine_b = {
				{ "branch", color = { gui = "bold" } },
				"diff",
				{ "diagnostics", color = { gui = "bold" } },
			},
			lualine_c = {
				{ "filename", path = 0 },
			},
			lualine_x = {
				"encoding",
				{
					"fileformat",
					symbols = { unix = "" },
					color = { gui = "bold" },
				},
				"filetype",
			},
			lualine_y = {
				{ "progress", color = { gui = "bold" } },
			},
			lualine_z = {
				{ "location", color = { gui = "bold" } },
			},
		},
	},
}
