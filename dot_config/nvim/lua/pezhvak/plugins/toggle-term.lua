return {
	"akinsho/toggleterm.nvim",
	version = "*",
	config = function()
		require("toggleterm").setup({
			open_mapping = [[<c-\>]],
			-- Don't yank the view back to the bottom on every chunk of output;
			-- lets you scroll up in normal mode while a TUI is still streaming.
			auto_scroll = false,
		})

		local Terminal = require("toggleterm.terminal").Terminal
		local events = require("neo-tree.events")
		local refresh_group = vim.api.nvim_create_augroup("ToggleTermNeoTreeRefresh", { clear = true })
		local lazygit = Terminal:new({
			cmd = "lazygit",
			hidden = true,
			direction = "float",
			float_opts = {
				border = "none",
				display_name = "LazyGit",
				width = 160,
				height = 32,
			},
		})

		local function lazy_git_toggle()
			lazygit:toggle()
		end

		local floatTerm = Terminal:new({
			hidden = true,
			direction = "float",
			title_pos = "center",
			float_opts = {
				border = "none",
				display_name = "Terminal",
				width = 160,
				height = 32,
			},
		})

		local function float_term_toggle()
			floatTerm:toggle()
		end

		local codexTerm = Terminal:new({
			cmd = "codex",
			hidden = true,
			direction = "float",
			close_on_exit = false,
			title_pos = "center",
			float_opts = {
				border = "none",
				display_name = "Codex",
				width = 160,
				height = 32,
			},
		})

		local function codex_term_toggle()
			codexTerm:toggle()
		end

		local opencodeTerm = Terminal:new({
			cmd = "opencode",
			hidden = true,
			direction = "float",
			close_on_exit = false,
			title_pos = "center",
			float_opts = {
				border = "none",
				display_name = "OpenCode",
				width = 160,
				height = 32,
			},
		})

		local function opencode_term_toggle()
			opencodeTerm:toggle()
		end

		local claudeTerm = Terminal:new({
			cmd = "claude",
			hidden = true,
			direction = "float",
			close_on_exit = false,
			title_pos = "center",
			float_opts = {
				border = "none",
				display_name = "Claude",
				width = 160,
				height = 32,
			},
		})

		local function claude_term_toggle()
			claudeTerm:toggle()
		end

		local k9sTerm = Terminal:new({
			cmd = "k9s",
			hidden = true,
			direction = "float",
			close_on_exit = false,
			title_pos = "center",
			float_opts = {
				border = "none",
				display_name = "K9s",
				width = 160,
				height = 32,
			},
		})

		local function k9s_term_toggle()
			k9sTerm:toggle()
		end

		local function close_all_terminals()
			lazygit:close()
			floatTerm:close()
			codexTerm:close()
			opencodeTerm:close()
			claudeTerm:close()
			k9sTerm:close()
		end

		vim.api.nvim_create_autocmd("TermClose", {
			group = refresh_group,
			callback = function(args)
				local buf_name = vim.api.nvim_buf_get_name(args.buf)
				if buf_name:match("lazygit") then
					events.fire_event(events.GIT_EVENT)
				end
			end,
		})

		vim.keymap.set("n", "<leader>;g", lazy_git_toggle, { desc = "Toggle LazyGit", silent = true })
		vim.keymap.set("n", "<leader>;t", float_term_toggle, { desc = "Toggle floating terminal", silent = true })
		vim.keymap.set("n", "<leader>;x", codex_term_toggle, { desc = "Toggle Codex terminal", silent = true })
		vim.keymap.set("n", "<leader>;o", opencode_term_toggle, { desc = "Toggle OpenCode terminal", silent = true })
		vim.keymap.set("n", "<leader>;c", claude_term_toggle, { desc = "Toggle Claude terminal", silent = true })
		vim.keymap.set("n", "<leader>;k", k9s_term_toggle, { desc = "Toggle K9s terminal", silent = true })
		vim.keymap.set("t", "<c-w>", close_all_terminals, { desc = "Close all floating terminals", silent = true })
	end,
}
