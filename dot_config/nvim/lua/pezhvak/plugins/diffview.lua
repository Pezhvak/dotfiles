-- Friendly git review: file panel + side-by-side diff in its own tab.
-- Heads-up: mapping plain <C-w> inside diffview buffers shadows the
-- window-prefix — use <C-w><C-w> if you need a window motion in there.

local FT_FILES = 'DiffviewFiles'
local FT_HIST = 'DiffviewFileHistory'

return {
  {
    'sindrets/diffview.nvim',
    cmd = {
      'DiffviewOpen',
      'DiffviewClose',
      'DiffviewToggleFiles',
      'DiffviewFocusFiles',
      'DiffviewRefresh',
      'DiffviewFileHistory',
    },
    keys = {
      { '<leader>gv', '<cmd>DiffviewOpen<cr>',          desc = 'git re[v]iew' },
      { '<leader>gV', '<cmd>DiffviewFileHistory<cr>',   desc = 'git [V]iew repo history' },
      { '<leader>gf', '<cmd>DiffviewFileHistory %<cr>', desc = 'git [f]ile history (current buffer)' },
    },
    opts = {},
    init = function()
      local group = vim.api.nvim_create_augroup('DiffviewClose', { clear = true })

      -- <C-w> closes diffview from any buffer inside its tab (panels and
      -- both diff sides). WinEnter covers files navigated to via <Tab>.
      vim.api.nvim_create_autocmd({ 'WinEnter', 'BufWinEnter', 'FileType' }, {
        group = group,
        callback = function(ev)
          for _, w in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
            local b = vim.api.nvim_win_get_buf(w)
            local ft = vim.api.nvim_buf_is_valid(b) and vim.bo[b].filetype or ''
            if ft == FT_FILES or ft == FT_HIST then
              vim.keymap.set('n', '<C-w>', '<cmd>DiffviewClose<cr>',
                { buffer = ev.buf, desc = 'diffview: close' })
              return
            end
          end
        end,
      })

      -- gopls (and other servers that validate URIs) reject diffview's
      -- `diffview://` scheme with a JSON-RPC parse error. Detach any client
      -- that lsp-config auto-attached to a diffview buffer.
      vim.api.nvim_create_autocmd('LspAttach', {
        group = group,
        callback = function(ev)
          if vim.api.nvim_buf_get_name(ev.buf):match '^diffview://' then
            vim.schedule(function()
              pcall(vim.lsp.buf_detach_client, ev.buf, ev.data.client_id)
            end)
          end
        end,
      })
    end,
  },
}
