return { -- You can easily change to a different colorscheme.
  -- Change the name of the colorscheme plugin below, and then
  -- change the command in the config to whatever the name of that colorscheme is.
  --
  -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
  'folke/tokyonight.nvim',
  priority = 1000, -- Make sure to load this before all the other start plugins.
  config = function()
    ---@diagnostic disable-next-line: missing-fields
    require('tokyonight').setup {
      transparent = true,
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
        sidebars = 'transparent',
        floats = 'transparent',
      },
      on_colors = function(colors)
        colors.bg_statusline = colors.none -- or "NONE"
      end,
    }

    -- Apply the persisted colorscheme from the previous session, or fall back
    -- to tokyonight-night. Lazy.nvim's colorscheme handler will load the
    -- providing plugin on demand even if it's `lazy = true`.
    local saved
    local fd = io.open(vim.fn.stdpath 'state' .. '/last-colorscheme', 'r')
    if fd then
      saved = fd:read '*l'
      fd:close()
    end
    if not (saved and saved ~= '' and pcall(vim.cmd.colorscheme, saved)) then
      vim.cmd.colorscheme 'tokyonight-night'
    end
  end,
}
