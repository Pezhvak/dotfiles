return {
  'vim-test/vim-test',
  cmd = { 'TestNearest', 'TestFile', 'TestSuite', 'TestLast', 'TestVisit' },
  keys = {
    { '<leader>tn', '<cmd>TestNearest<cr>', desc = '[T]est [n]earest' },
    { '<leader>tf', '<cmd>TestFile<cr>',    desc = '[T]est [f]ile' },
    { '<leader>ts', '<cmd>TestSuite<cr>',   desc = '[T]est [s]uite' },
    { '<leader>tl', '<cmd>TestLast<cr>',    desc = '[T]est [l]ast' },
    { '<leader>tv', '<cmd>TestVisit<cr>',   desc = '[T]est [v]isit' },
  },
}
