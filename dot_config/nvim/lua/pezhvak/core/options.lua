-- [[ Setting options ]]
-- encoding
vim.scriptencoding = 'utf-8'
vim.opt.encoding = 'utf-8'
vim.opt.fileencoding = 'utf-8'

-- nerd font
vim.g.have_nerd_font = true

-- number bar settings
vim.o.number = true
vim.o.relativenumber = true
vim.o.numberwidth = 4
vim.o.ruler = false

-- tabs
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.softtabstop = 4
vim.opt.autoindent = true
vim.opt.smartindent = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.o.mouse = 'a'

-- status bar
vim.opt.laststatus = 3 -- this status line will take entire screen
vim.opt.showmode = false -- Don't show the mode, since it's already in the status line
vim.opt.title = true
vim.opt.titlestring = '%{fnamemodify(getcwd(), ":t")}'
vim.opt.cmdheight = 0 -- remove empty space command bar at the bottom of screen

-- spell check
vim.opt.spell = false

-- Sync clipboard between OS and Neovim.
-- Schedule the setting after `UiEnter` because it can increase startup-time.
-- Remove this option if you want your OS clipboard to remain independent.
-- See `:help 'clipboard'`
vim.schedule(function()
  if vim.fn.has 'clipboard' == 1 then
    vim.o.clipboard = 'unnamedplus'
  end
end)

-- This indicates if line wraps, should it continue from start of the line or keep indentation
vim.o.breakindent = false

-- Save undo history
vim.o.undofile = true
vim.o.undodir = os.getenv 'HOME' .. '/.vim/undodir'
vim.fn.mkdir(vim.o.undodir, 'p')
vim.o.swapfile = false -- rely on persistent undo, skip the .swp clutter

-- search settings
vim.o.ignorecase = true
vim.o.smartcase = true
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- appearance
vim.opt.termguicolors = true
vim.opt.background = 'dark'
vim.o.signcolumn = 'yes' -- Keep signcolumn on by default
vim.o.cursorline = true -- Highlight the line your currently at
vim.o.cursorlineopt = 'number' -- only the line number, not the whole row
vim.o.winborder = 'rounded' -- consistent rounded borders for every float

-- Decrease update time
vim.o.updatetime = 250

-- Reload buffer when the file changes on disk (paired with checktime autocmds)
vim.o.autoread = true

-- Backspace key
vim.opt.backspace = 'indent,eol,start'

-- Decrease mapped sequence wait time
vim.o.timeoutlen = 300

-- Configure how new splits should be opened
vim.o.splitright = true
vim.o.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
--
--  Notice listchars is set using `vim.opt` instead of `vim.o`.
--  It is very similar to `vim.o` but offers an interface for conveniently interacting with tables.
--   See `:help lua-options`
--   and `:help lua-options-guide`
vim.o.list = true -- show tabs, trailing whitespace, and non-breaking spaces
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.o.inccommand = 'split'

-- Minimal number of screen lines to keep above and below the cursor.
vim.o.scrolloff = 5
vim.opt.sidescrolloff = 8

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
vim.o.confirm = true

-- autocomplete
vim.opt.completeopt = 'menuone,noselect'
vim.opt.wildmode = { 'longest', 'full', 'full' }

-- fold
vim.o.foldcolumn = '1' -- '0' is not bad
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true
