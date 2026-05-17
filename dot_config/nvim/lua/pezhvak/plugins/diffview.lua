-- Friendly git review: file panel + side-by-side diff in its own tab.
-- Toggleterm-style UX: <leader>gv opens, hides, or re-focuses; the tab is
-- hidden from the tabline while diffview is the only extra tab.
-- Heads-up: mapping plain <C-w> shadows the window-prefix inside diffview
-- buffers — use <C-w><C-w> if you need a window motion in there.

local FT_FILES = 'DiffviewFiles'
local FT_HIST = 'DiffviewFileHistory'

local function tab_has_ft(tp, fts)
  for _, w in ipairs(vim.api.nvim_tabpage_list_wins(tp)) do
    local b = vim.api.nvim_win_get_buf(w)
    if vim.api.nvim_buf_is_valid(b) then
      local ft = vim.bo[b].filetype
      for _, target in ipairs(fts) do
        if ft == target then return true end
      end
    end
  end
  return false
end

local function find_tab_with_ft(target_ft)
  for _, tp in ipairs(vim.api.nvim_list_tabpages()) do
    if tab_has_ft(tp, { target_ft }) then return tp end
  end
  return nil
end

local function in_diffview_tab()
  return tab_has_ft(vim.api.nvim_get_current_tabpage(), { FT_FILES, FT_HIST })
end

-- Hide by jumping to the user's "home" tab — prefer the last-accessed tab,
-- but skip it if it's itself a diffview tab (otherwise hiding gV would land
-- on hidden gv instead of the real code). Falls through to any non-diffview
-- tab, then any other tab as a last resort.
local function hide_diffview()
  local tabs = vim.api.nvim_list_tabpages()
  if #tabs <= 1 then return end
  local current = vim.api.nvim_get_current_tabpage()

  local last_nr = vim.fn.tabpagenr '#'
  local last_tp = last_nr > 0 and tabs[last_nr] or nil
  if last_tp and last_tp ~= current and not tab_has_ft(last_tp, { FT_FILES, FT_HIST }) then
    vim.api.nvim_set_current_tabpage(last_tp)
    return
  end

  for _, tp in ipairs(tabs) do
    if tp ~= current and not tab_has_ft(tp, { FT_FILES, FT_HIST }) then
      vim.api.nvim_set_current_tabpage(tp)
      return
    end
  end

  vim.cmd 'tabprevious'
end

local function make_toggle(target_ft, open_cmd)
  return function()
    local target = find_tab_with_ft(target_ft)
    if target then
      if vim.api.nvim_get_current_tabpage() == target then
        hide_diffview()
      else
        vim.api.nvim_set_current_tabpage(target)
      end
    else
      vim.cmd(open_cmd)
    end
  end
end

-- Auto-hide the tabline while every "extra" tab is a diffview tab.
local function update_tabline()
  local total = vim.fn.tabpagenr '$'
  local dv = 0
  for _, tp in ipairs(vim.api.nvim_list_tabpages()) do
    for _, w in ipairs(vim.api.nvim_tabpage_list_wins(tp)) do
      local b = vim.api.nvim_win_get_buf(w)
      local ft = vim.api.nvim_buf_is_valid(b) and vim.bo[b].filetype or ''
      if ft == FT_FILES or ft == FT_HIST then
        dv = dv + 1
        break
      end
    end
  end
  vim.o.showtabline = (dv > 0 and (total - dv) <= 1) and 0 or 1
end

local function set_hide_keys(bufnr)
  vim.keymap.set('n', '<Esc>', hide_diffview, { buffer = bufnr, desc = 'diffview: hide' })
  vim.keymap.set('n', '<C-w>', hide_diffview, { buffer = bufnr, desc = 'diffview: hide' })
end

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
      { '<leader>gv', make_toggle(FT_FILES, 'DiffviewOpen'),        desc = 'git re[v]iew (toggle)' },
      { '<leader>gV', make_toggle(FT_HIST, 'DiffviewFileHistory'),  desc = 'git [V]iew repo history (toggle)' },
      { '<leader>gf', '<cmd>DiffviewFileHistory %<cr>',             desc = 'git [f]ile history (current buffer)' },
    },
    opts = {},
    init = function()
      local group = vim.api.nvim_create_augroup('DiffviewToggle', { clear = true })

      -- Apply hide keys to every buffer that becomes visible inside a
      -- diffview tab — covers panels, both diff sides, and files navigated
      -- to via <Tab>/<S-Tab>. WinEnter is reliable where the diffview
      -- User events were not.
      vim.api.nvim_create_autocmd({ 'WinEnter', 'BufWinEnter' }, {
        group = group,
        callback = function(ev)
          if in_diffview_tab() then
            set_hide_keys(ev.buf)
          end
        end,
      })

      vim.api.nvim_create_autocmd('FileType', {
        group = group,
        pattern = { FT_FILES, FT_HIST },
        callback = function(ev)
          set_hide_keys(ev.buf)
          vim.schedule(update_tabline)
        end,
      })

      vim.api.nvim_create_autocmd({ 'TabNew', 'TabClosed', 'TabEnter' }, {
        group = group,
        callback = function()
          vim.schedule(update_tabline)
        end,
      })

      -- On :q from a normal tab, dispose hidden diffview tabs so nvim can
      -- exit cleanly instead of surfacing them one by one.
      vim.api.nvim_create_autocmd('QuitPre', {
        group = group,
        callback = function()
          if in_diffview_tab() then return end
          local current = vim.api.nvim_get_current_tabpage()
          for _, tp in ipairs(vim.api.nvim_list_tabpages()) do
            if tp ~= current and tab_has_ft(tp, { FT_FILES, FT_HIST }) then
              pcall(vim.api.nvim_set_current_tabpage, tp)
              pcall(vim.cmd, 'DiffviewClose')
            end
          end
          if vim.api.nvim_tabpage_is_valid(current) then
            vim.api.nvim_set_current_tabpage(current)
          end
        end,
      })
    end,
  },
}
