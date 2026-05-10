return {
  'akinsho/toggleterm.nvim',
  version = '*',
  config = function()
    require('toggleterm').setup {
      open_mapping = [[<c-\>]],
    }

    local Terminal = require('toggleterm.terminal').Terminal
    local lazygit = Terminal:new {
      cmd = 'lazygit',
      hidden = true,
      direction = 'float',
      float_opts = {
        border = 'none',
        display_name = 'LazyGit',
        width = 160,
        height = 32,
      },
    }

    function LazyGitToggle()
      lazygit:toggle()
      -- this ensures nvim tree gets refreshed after closing lazygit
      -- otherwise you have to manually refresh it
      vim.api.nvim_create_autocmd({ 'BufLeave' }, {
        buffer = 0, -- or maybe vim.api.nvim_get_current_buf()
        callback = function()
          local events = require 'neo-tree.events'
          events.fire_event(events.GIT_EVENT)
        end,
      })
    end

    local floatTerm = Terminal:new {
      hidden = true,
      direction = 'float',
      title_pos = 'center',
      float_opts = {
        border = 'none',
        display_name = 'Terminal',
        width = 160,
        height = 32,
      },
    }

    function FloatTermToggle()
      floatTerm:toggle()
    end

    function CloseAllTerminals()
      lazygit:close()
      floatTerm:close()
      -- vim.cmd(":ToggleTermToggleAll")
    end

    vim.api.nvim_set_keymap('n', '<leader>tg', '<cmd>lua LazyGitToggle()<CR>', { noremap = true, silent = true })
    -- vim.api.nvim_set_keymap("t", "<leader>tg", "<cmd>lua LazyGitToggle()<CR>", { noremap = true, silent = true })
    vim.api.nvim_set_keymap('n', '<leader>tt', '<cmd>lua FloatTermToggle()<CR>', { noremap = true, silent = true })
    -- vim.api.nvim_set_keymap("t", "<leader>tt", "<cmd>lua FloatTermToggle()<CR>", { noremap = true, silent = true })
    vim.api.nvim_set_keymap('t', '<c-w>', '<cmd>lua CloseAllTerminals()<CR>', { noremap = true, silent = true })
  end,
}
