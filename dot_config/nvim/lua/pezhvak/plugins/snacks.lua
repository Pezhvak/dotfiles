return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    -- Disabled modules and what replaces them:
    --   explorer → neo-tree.nvim + oil.nvim
    --   indent   → indent-blankline.nvim (ibl)
    --   scope    → companion to indent; not needed without snacks.indent
    --   words    → vim-illuminate
    --   picker   → telescope.nvim is the primary picker (LSP, ui-select, all <leader>s* binds)
    bigfile = { enabled = true },
    dashboard = {
      enabled = true,
      preset = {
        header = [[
██████╗ ███████╗███████╗██╗  ██╗██╗   ██╗ █████╗ ██╗  ██╗
██╔══██╗██╔════╝╚══███╔╝██║  ██║██║   ██║██╔══██╗██║ ██╔╝
██████╔╝█████╗    ███╔╝ ███████║██║   ██║███████║█████╔╝ 
██╔═══╝ ██╔══╝   ███╔╝  ██╔══██║╚██╗ ██╔╝██╔══██║██╔═██╗ 
██║     ███████╗███████╗██║  ██║ ╚████╔╝ ██║  ██║██║  ██╗
╚═╝     ╚══════╝╚══════╝╚═╝  ╚═╝  ╚═══╝  ╚═╝  ╚═╝╚═╝  ╚═╝]],
        keys = {
          { icon = ' ', key = 'f', desc = 'Find File',    action = ':Telescope find_files' },
          { icon = ' ', key = 'n', desc = 'New File',     action = ':ene | startinsert' },
          { icon = ' ', key = 'g', desc = 'Find Text',    action = ':Telescope live_grep' },
          { icon = ' ', key = 'r', desc = 'Recent Files', action = ':Telescope oldfiles' },
          { icon = ' ', key = 'c', desc = 'Config',       action = ":lua require('telescope.builtin').find_files({ cwd = vim.fn.stdpath('config') })" },
          { icon = '󰒲 ', key = 'L', desc = 'Lazy',         action = ':Lazy' },
          { icon = ' ', key = 'q', desc = 'Quit',         action = ':qa' },
        },
      },
      sections = {
        { section = 'header' },
        { section = 'keys', gap = 1, padding = 1 },
      },
    },
    input = { enabled = true },
    notifier = {
      timeout = 3000,
      enabled = true,
      top_down = false, -- places notifications at the bottom right of the screen
    },
    quickfile = { enabled = true },
    scroll = {
      enabled = true,
      filter = function(buf)
        return vim.g.snacks_scroll ~= false and vim.b[buf].snacks_scroll ~= false and vim.bo[buf].buftype ~= 'terminal'
      end,
    },
    statuscolumn = { enabled = true },
  },
}
