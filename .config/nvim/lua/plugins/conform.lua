return {
	"stevearc/conform.nvim",
	event = "BufWritePre",
	keys = {
		{
			"<leader>cf",
			function()
				require("conform").format()
			end,
		},
	},
	opts = {
		format_on_save = function(bufnr)
			local filetype = vim.bo[bufnr].filetype
			if filetype == "vue" or filetype == "scss" then
				return nil
			end

			return { timeout_ms = 3000 }
		end,
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "ruff_organize_imports", "ruff_format" },
			rust = { "rustfmt" },
			javascript = { "oxfmt" },
			typescript = { "oxfmt" },
			javascriptreact = { "oxfmt" },
			typescriptreact = { "oxfmt" },
			vue = { "oxfmt" },
			css = { "oxfmt" },
			scss = { "oxfmt" },
			less = { "oxfmt" },
			html = { "oxfmt" },
			json = { "oxfmt" },
			jsonc = { "oxfmt" },
			yaml = { "oxfmt" },
			["yaml.docker-compose"] = { "oxfmt" },
			markdown = { "oxfmt" },
			["markdown.mdx"] = { "oxfmt" },
			graphql = { "oxfmt" },
			toml = { "oxfmt" },
			-- Svelte and Astro use LSP fallback; Oxfmt does not support these filetypes yet.
		},
		default_format_opts = {
			lsp_format = "fallback",
		},
	},
}
