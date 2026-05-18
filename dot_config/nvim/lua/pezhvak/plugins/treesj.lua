return {
  'Wansmer/treesj',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  keys = {
    { '<leader>m', function() require('treesj').toggle() end, desc = 'Split/Join block' },
    { '<leader>M', function() require('treesj').toggle({ split = { recursive = true } }) end, desc = 'Split/Join block (recursive)' },
  },
  opts = {
    use_default_keymaps = false,
    max_join_length = 240,
  },
}
