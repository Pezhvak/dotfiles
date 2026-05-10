return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
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
      },
      sections = {
        { section = 'header' },
        { section = 'keys', gap = 1, padding = 1 },
      },
    },
    explorer = { enabled = true },
    indent = { enabled = true },
    input = { enabled = true },
    picker = { enabled = true },
    notifier = {
      timeout = 3000,
      enabled = true,
      top_down = false, -- places notifications at the bottom right of the screen
    },
    quickfile = { enabled = true },
    scope = { enabled = true },
    scroll = {
      enabled = true,
      filter = function(buf)
        return vim.g.snacks_scroll ~= false and vim.b[buf].snacks_scroll ~= false and vim.bo[buf].buftype ~= 'terminal'
      end,
    },
    statuscolumn = { enabled = true },
    words = { enabled = true },
  },
}
