return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		win = { border = "rounded" },
		spec = {
			{ "<leader>f", group = "Find" },
			{ "<leader>c", group = "Code" },
			{ "<leader>r", group = "Refactor" },
			{ "<leader>h", group = "Git hunk" },
		},
	},
}
