return {
  'RRethy/vim-illuminate',
  event = { 'BufReadPost', 'BufNewFile' },
  config = function()
    require('illuminate').configure {
      providers = {
        'lsp',
        'treesitter',
        'regex',
      },
      delay = 100,
      filetypes_denylist = {
        'dirvish',
        'fugitive',
        'NvimTree',
        'toggleterm',
        'TelescopePrompt',
        'alpha',
        'lazy',
        'mason',
        'neo-tree',
        'Outline',
        'spectre_panel',
      },
      under_cursor = true,
    }
  end,
}
