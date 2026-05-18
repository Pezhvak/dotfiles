return { -- Detect tabstop and shiftwidth automatically
	"NMAC427/guess-indent.nvim",
	config = function()
		require("guess-indent").setup({
			filetype_exclude = {
				"netrw",
				"tutor",
				"javascript",
				"javascriptreact",
				"typescript",
				"typescriptreact",
				"json",
				"jsonc",
				"css",
				"scss",
				"html",
				"vue",
				"svelte",
				"graphql",
				"markdown",
				"yaml",
			},
		})
	end,
}
