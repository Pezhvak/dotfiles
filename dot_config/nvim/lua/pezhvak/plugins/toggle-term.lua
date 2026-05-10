return {
	"akinsho/toggleterm.nvim",
	version = "*",
	config = function()
		require("toggleterm").setup({
			open_mapping = [[<c-\>]],
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

		local function close_all_terminals()
			lazygit:close()
			floatTerm:close()
			codexTerm:close()
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

		vim.keymap.set("n", "<leader>tg", lazy_git_toggle, { desc = "Toggle LazyGit", silent = true })
		vim.keymap.set("n", "<leader>tt", float_term_toggle, { desc = "Toggle floating terminal", silent = true })
		vim.keymap.set("n", "<leader>tc", codex_term_toggle, { desc = "Toggle Codex terminal", silent = true })
		vim.keymap.set("t", "<c-w>", close_all_terminals, { desc = "Close all floating terminals", silent = true })
	end,
}
