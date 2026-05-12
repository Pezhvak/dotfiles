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

-- Remove comment leader when inserting a new line
vim.cmd([[autocmd FileType * set formatoptions-=ro]])

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
