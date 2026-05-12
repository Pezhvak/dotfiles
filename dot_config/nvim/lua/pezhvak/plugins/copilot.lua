-- copilot
return {
	"github/copilot.vim",
	init = function()
		vim.g.copilot_no_tab_map = true
		vim.g.copilot_assume_mapped = true

		vim.keymap.set("i", "<Tab>", 'copilot#Accept("\\<Tab>")', {
			expr = true,
			replace_keycodes = false,
			silent = true,
		})
	end,
}
