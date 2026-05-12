-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  desc = 'Enable spell check only for prose-like filetypes',
  group = vim.api.nvim_create_augroup('pezhvak-prose-spell', { clear = true }),
  pattern = { 'gitcommit', 'markdown', 'text' },
  callback = function()
    vim.opt_local.spell = true
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  desc = 'Wrap prose at 80 columns',
  group = vim.api.nvim_create_augroup('pezhvak-prose-wrap', { clear = true }),
  pattern = { 'gitcommit', 'markdown', 'text' },
  callback = function()
    vim.opt_local.textwidth = 80
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.breakindent = true
    vim.opt_local.formatoptions:append { 't', 'q' }
  end,
})

-- Remove comment leader when inserting a new line
vim.cmd [[autocmd FileType * set formatoptions-=ro]]

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
