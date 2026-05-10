return {
  'stevearc/oil.nvim',
  dependencies = { { 'nvim-mini/mini.icons', opts = {} } },
  config = function()
    require('oil').setup {
      default_file_explorer = true,
      view_options = {
        -- Show files and directories that start with "."
        show_hidden = true,
        is_always_hidden = function(name, bufnr)
          if name == '.DS_Store' then
            return true
          end
          if name == '.git' then
            return true
          end
          if name == '.github' then
            return true
          end

          return false
        end,
      },
      columns = {
        'icon',
        'permissions',
        'size',
        'mtime',
      },
      keymaps = {
        -- ['<Esc>'] = 'actions.close',
        ['q'] = 'actions.close',
        ['<C-w>'] = 'actions.close',
        ['<C-p>'] = 'actions.preview',
      },
      float = {
        -- Padding around the floating window
        padding = 2,
        max_width = 0,
        max_height = 0,
        border = 'rounded',
        win_options = {
          winblend = 0,
        },
        -- This is the config that will be passed to nvim_open_win.
        -- Change values here to customize the layout
        override = function(conf)
          return conf
        end,
      },
    }
    vim.keymap.set('n', '-', '<CMD>Oil --float<CR>', { desc = 'Open parent directory' })
  end,
}
