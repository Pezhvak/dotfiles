-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	desc = "Enable spell check only for prose-like filetypes",
	group = vim.api.nvim_create_augroup("pezhvak-prose-spell", { clear = true }),
	pattern = { "gitcommit", "markdown", "text" },
	callback = function()
		vim.opt_local.spell = true
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	desc = "Wrap prose at 80 columns",
	group = vim.api.nvim_create_augroup("pezhvak-prose-wrap", { clear = true }),
	pattern = { "gitcommit", "markdown", "text" },
	callback = function()
		vim.opt_local.textwidth = 80
		vim.opt_local.wrap = true
		vim.opt_local.linebreak = true
		vim.opt_local.breakindent = true
		vim.opt_local.formatoptions:append({ "t", "q" })
	end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
	desc = "Hard-wrap markdown paragraphs at 80 columns on save",
	group = vim.api.nvim_create_augroup("pezhvak-markdown-hard-wrap", { clear = true }),
	pattern = "*.md",
	callback = function()
		local view = vim.fn.winsaveview()
		local was_modified = vim.bo.modified

		vim.cmd([[silent keepjumps normal! ggVGgq]])

		if not was_modified and vim.bo.modified then
			vim.bo.modified = false
		end

		vim.fn.winrestview(view)
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	desc = "Wrap yaml comments at 80 columns",
	group = vim.api.nvim_create_augroup("pezhvak-yaml-wrap", { clear = true }),
	pattern = { "yaml" },
	callback = function()
		vim.opt_local.textwidth = 80
		vim.opt_local.formatoptions:append({ "c", "q" })
	end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
	desc = "Hard-wrap yaml comment blocks at 80 columns on save",
	group = vim.api.nvim_create_augroup("pezhvak-yaml-comment-hard-wrap", { clear = true }),
	pattern = { "*.yaml", "*.yml" },
	callback = function()
		local view = vim.fn.winsaveview()
		local lnum = 1
		local line_count = vim.api.nvim_buf_line_count(0)

		while lnum <= line_count do
			local line = vim.fn.getline(lnum)
			if line:match("^%s*#") then
				local start_lnum = lnum
				repeat
					lnum = lnum + 1
					line = vim.fn.getline(lnum)
				until lnum > line_count or not line:match("^%s*#")

				local end_lnum = lnum - 1
				vim.cmd(string.format("silent keepjumps normal! %dGV%dGgq", start_lnum, end_lnum))
			else
				lnum = lnum + 1
			end

			line_count = vim.api.nvim_buf_line_count(0)
		end

		vim.fn.winrestview(view)
	end,
})

-- Auto-reload buffers when the underlying file changes on disk. `autoread`
-- alone only reloads on certain events; firing `checktime` on focus, buffer
-- enter, and cursor-hold catches edits made by other tools (formatters,
-- git pulls, AI agents) without needing to :e!.
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
	group = vim.api.nvim_create_augroup("pezhvak-autoread-checktime", { clear = true }),
	desc = "Check for external file changes and reload buffers",
	callback = function()
		if vim.fn.mode() ~= "c" and vim.bo.buftype == "" then
			vim.cmd("checktime")
		end
	end,
})

vim.api.nvim_create_autocmd("FileChangedShellPost", {
	group = vim.api.nvim_create_augroup("pezhvak-autoread-notify", { clear = true }),
	desc = "Notify when a buffer was reloaded due to an external change",
	callback = function()
		vim.notify("File changed on disk; buffer reloaded", vim.log.levels.INFO)
	end,
})

-- Remove comment leader when inserting a new line
vim.cmd([[autocmd FileType * set formatoptions-=ro]])

-- Persist the active colorscheme across nvim restarts. Read back in
-- tokyonight.lua's config function on startup. Use args.match (the name
-- passed to :colorscheme) instead of vim.g.colors_name, because some
-- plugins (rose-pine, kanagawa) overwrite colors_name with their base
-- name and lose the variant.
vim.api.nvim_create_autocmd("ColorScheme", {
	group = vim.api.nvim_create_augroup("pezhvak-persist-colorscheme", { clear = true }),
	desc = "Save the active colorscheme to state for the next session",
	callback = function(args)
		local name = args.match
		if not name or name == "" then
			return
		end
		local fd = io.open(vim.fn.stdpath("state") .. "/last-colorscheme", "w")
		if fd then
			fd:write(name)
			fd:close()
		end
	end,
})

-- In terminal buffers (toggleterm floats, :terminal), forward the mouse wheel
-- to the running TUI instead of scrolling nvim's view of the terminal buffer.
-- Without this, scrolling inside claude/codex/lazygit/k9s drops you into
-- nvim's terminal scrollback, which renders alternate-screen TUIs as garbled
-- fragments of past frames until the TUI repaints.
vim.api.nvim_create_autocmd("TermOpen", {
	group = vim.api.nvim_create_augroup("pezhvak-term-scroll-passthrough", { clear = true }),
	desc = "Forward scroll wheel to the running TUI inside terminal buffers",
	callback = function(args)
		local function forward(key)
			return function()
				vim.cmd("startinsert")
				vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, false, true), "n", false)
			end
		end
		local opts = { buffer = args.buf, silent = true }
		vim.keymap.set("n", "<ScrollWheelUp>", forward("<ScrollWheelUp>"), opts)
		vim.keymap.set("n", "<ScrollWheelDown>", forward("<ScrollWheelDown>"), opts)
		vim.keymap.set("n", "<S-ScrollWheelUp>", forward("<S-ScrollWheelUp>"), opts)
		vim.keymap.set("n", "<S-ScrollWheelDown>", forward("<S-ScrollWheelDown>"), opts)
	end,
})

-- Golang auto imports on save
-- vim.api.nvim_create_autocmd('BufWritePre', {
--   pattern = '*.go',
--   desc = 'Golang auto imports on save',
--   group = vim.api.nvim_create_augroup('GoImportOnSave', { clear = true }),
--   callback = function()
--     -- vim.lsp.buf.code_action { only = { 'source.organizeImports' } }
--     require('go.format').goimports()
--
--     -- vim.lsp.buf.code_action {
--     --   context = {
--     --     only = { 'source.organizeImports' },
--     --     diagnostics = {},
--     --   },
--     --   apply = true,
--     -- }
--   end,
-- })
