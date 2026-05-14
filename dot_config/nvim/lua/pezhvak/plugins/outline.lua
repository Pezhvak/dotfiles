return {
  'hedyhli/outline.nvim',
  cmd = 'Outline',
  keys = {
    { '<leader>o', '<cmd>Outline<CR>', desc = 'Toggle Outline' },
  },
  opts = {
    outline_window = {
      position = 'right',
      width = 25,
      relative_width = true,
      auto_close = false,
    },
  },
}
