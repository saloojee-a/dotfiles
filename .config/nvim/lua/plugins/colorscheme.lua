return {
	"folke/tokyonight.nvim",
	priority = 1000,
	config = function()
		require("tokyonight").setup({
			style = "night",
			cache = false,
			transparent = false,
			styles = {
				sidebars = "normal",
				floats = "normal",
				comments = { italic = true },
				keywords = { italic = true, bold = true },
				functions = { bold = true },
			},
			on_colors = function(colors)
				-- Re-read the generated palette on every colorscheme reload.
				local palette = vim.json.decode(
					table.concat(vim.fn.readfile(vim.fn.stdpath("config") .. "/tokyonight-night.json"), "\n")
				)
				for name, value in pairs(palette) do
					colors[name] = vim.deepcopy(value)
				end
			end,
			on_highlights = function(hl, colors)
				-- Keep floating cards distinct from the editor backdrop.
				hl.FloatBorder = { fg = colors.fg_gutter, bg = colors.bg }
				hl.FloatTitle = { fg = colors.blue, bg = colors.bg, bold = true }

				hl.GitSignsAdd = { fg = colors.green }
				hl.GitSignsChange = { fg = colors.blue }
				hl.GitSignsDelete = { fg = colors.red }
				hl.GitSignsChangedelete = { fg = colors.yellow }
				hl.GitSignsUntracked = { fg = colors.comment }

				-- Lualine reads these groups for its diff component.
				hl.LuaLineDiffAdd = { fg = colors.green1 }
				hl.LuaLineDiffChange = { fg = colors.blue }
				hl.LuaLineDiffDelete = { fg = colors.red }

				hl.BlinkCmpMenu = { link = "Pmenu" }
				hl.BlinkCmpMenuBorder = { fg = colors.fg_gutter, bg = colors.bg }
				hl.BlinkCmpMenuSelection = { link = "Visual" }
				hl.BlinkCmpDoc = { link = "NormalFloat" }
				hl.BlinkCmpDocBorder = { link = "FloatBorder" }
			end,
		})
		vim.cmd.colorscheme("tokyonight-night")
	end,
}
