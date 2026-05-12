return {
  'MeanderingProgrammer/render-markdown.nvim',
  ft = { 'markdown' },
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-mini/mini.nvim',
  },
  opts = {},
  keys = {
    { '<leader>mp', '<cmd>RenderMarkdown toggle<CR>', desc = 'Markdown preview toggle' },
    { '<leader>mP', '<cmd>RenderMarkdown preview<CR>', desc = 'Markdown side preview' },
  },
}
