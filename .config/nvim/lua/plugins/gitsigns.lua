return {
	"lewis6991/gitsigns.nvim",
	event = "BufReadPre",
	opts = {
		signs = {
			add = { text = "▎" },
			change = { text = "▎" },
			delete = { text = "▁" },
			topdelete = { text = "▁" },
			changedelete = { text = "▁" },
			untracked = { text = "▎" },
		},
		on_attach = function(buf)
			local gs = require("gitsigns")
			local map = function(mode, keys, func, desc, extra_opts)
				local opts = vim.tbl_extend("force", { buffer = buf, desc = desc }, extra_opts or {})
				vim.keymap.set(mode, keys, func, opts)
			end
			map("n", "]c", function()
				if vim.wo.diff then
					return "]c"
				end
				vim.schedule(function()
					gs.next_hunk()
				end)
				return "<Ignore>"
			end, "Next hunk", { expr = true })
			map("n", "[c", function()
				if vim.wo.diff then
					return "[c"
				end
				vim.schedule(function()
					gs.prev_hunk()
				end)
				return "<Ignore>"
			end, "Prev hunk", { expr = true })
			map("n", "<leader>hp", gs.preview_hunk, "Preview hunk")
			map("n", "<leader>hr", gs.reset_hunk, "Reset hunk")
			map("n", "<leader>hb", gs.blame_line, "Blame line")
		end,
	},
}
