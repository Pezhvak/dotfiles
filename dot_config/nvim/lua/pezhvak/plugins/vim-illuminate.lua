return {
	"RRethy/vim-illuminate",
	event = { "BufReadPost", "BufNewFile" },
	config = function()
		require("illuminate").configure({
			-- 'treesitter' provider is omitted intentionally: it calls into
			-- nvim-treesitter's `locals` module, which broke in recent versions
			-- (iter_node can become `false`, then `:parent()` errors). LSP +
			-- regex cover the same ground in practice.
			providers = {
				"lsp",
				"regex",
			},
			delay = 100,
			filetypes_denylist = {
				"dirvish",
				"fugitive",
				"NvimTree",
				"toggleterm",
				"TelescopePrompt",
				"alpha",
				"lazy",
				"mason",
				"neo-tree",
				"Outline",
				"spectre_panel",
			},
			under_cursor = true,
		})
	end,
}
