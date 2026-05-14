-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- disable arrow keys
vim.keymap.set('n', '<up>', '<nop>')
vim.keymap.set('n', '<down>', '<nop>')
vim.keymap.set('n', '<left>', '<nop>')
vim.keymap.set('n', '<right>', '<nop>')
vim.keymap.set('i', '<up>', '<nop>')
vim.keymap.set('i', '<down>', '<nop>')
vim.keymap.set('i', '<left>', '<nop>')
vim.keymap.set('i', '<right>', '<nop>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- NOTE: Some terminals have colliding keymaps or are not able to send distinct keycodes
-- vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
-- vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
-- vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
-- vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

-- Open current file externally
vim.keymap.set('n', '<leader>O', ':!open %<CR><CR>', { desc = 'Open current file externally' })

-- window control
vim.keymap.set('n', '<leader>wv', '<C-w>v', { desc = 'Split window vertically' })
vim.keymap.set('n', '<leader>wh', '<C-w>s', { desc = 'Split window horizontally' })
vim.keymap.set('n', '<leader>we', '<C-w>=', { desc = 'Even sizing windows' })
vim.keymap.set('n', '<leader>wx', ':close<CR>', { desc = 'Closing current window' })

-- tab control
vim.keymap.set('n', '<leader><tab>x', ':tabclose<CR>', { desc = 'Close tab' })
vim.keymap.set('n', '<leader><tab>n', ':tabn<CR>', { desc = 'Next tab' })
vim.keymap.set('n', '<leader><tab>p', ':tabp<CR>', { desc = 'Previous tab' })

-- wrapped lines j,k
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, desc = 'Move up wrapped lines' })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, desc = 'Move down wrapped lines' })

-- moving lines
vim.keymap.set('v', '>', '>gv', { desc = 'Indent lines right' })
vim.keymap.set('v', '<', '<gv', { desc = 'Indent lines left' })
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move lines down' })
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move lines up' })
vim.keymap.set('n', 'J', 'mzJ`z', { desc = 'Move below line to the end of here' })
vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'Page Down' })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Page Up' })
vim.keymap.set('n', 'n', 'nzzzv', { desc = 'Jump to next occurrence' })
vim.keymap.set('n', 'N', 'Nzzzv', { desc = 'Jump to previous occurrence' })

-- system clipboard copy
vim.keymap.set('v', 'y', 'myy`y', { desc = 'Yank without jump up' })
vim.keymap.set('n', '<leader>y', '"+y', { desc = 'Copy to system clipboard' })
vim.keymap.set('v', '<leader>y', '"+y', { desc = 'Copy to system clipboard' })
vim.keymap.set('n', '<leader>Y', '"+y', { desc = 'Copy to system clipboard' })

-- delete without yank
vim.keymap.set('n', '<leader>d', '"_d', { desc = 'Delete without yank' })

-- find files
vim.keymap.set('n', '<leader>ff', ':lua Snacks.dashboard.pick("files")<CR>', { desc = 'Find files' })

vim.keymap.set('n', 'K', function()
  vim.lsp.buf.hover {
    border = 'single',
  }
end)
