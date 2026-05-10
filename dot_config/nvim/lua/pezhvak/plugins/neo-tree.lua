-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  lazy = false,
  keys = {
    { '<leader>`', ':Neotree toggle<CR>', desc = 'NeoTree reveal', silent = true },
  },
  opts = {
    window = {
      position = 'right',
    },
    default_component_configs = {
      indent = {
        with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
        expander_collapsed = '',
        expander_expanded = '',
        expander_highlight = 'NeoTreeExpander',
      },
      icon = {
        folder_closed = '',
        folder_open = '',
        folder_empty = 'ﰊ',
        default = '',
        highlight = 'NeoTreeFileIcon',
      },
      modified = {
        symbol = '●', -- Text to show when the file is modified.
        highlight = 'NeoTreeModified',
      },
      name = {
        trailing_slash = false, -- whether to add a trailing slash to folder names
        use_git_status_colors = true,
        highlight = 'NeoTreeFileName',
      },
      git_status = {
        symbols = {
          added = '✚', -- or "✚", but this is redundant info if you use git_status_colors on the name
          modified = '', -- or "", but this is redundant info if you use git_status_colors on the name
          deleted = '✖', -- this can only be used in the git_status source
          renamed = '', -- this can only be used in the git_status source
          -- Status type can be one of:
          -- "unstaged", "staged", "unmerged", "renamed", "untracked", "deleted", "ignored"
          unstaged = '✗',
          staged = '✓',
          unmerged = '',
          untracked = '★',
          ignored = '◌',
        },
      },
    },
    filesystem = {
      follow_current_file = {
        enabled = true, -- This will find and focus the file in the active buffer every time
        --               -- the current file is changed while the tree is open.
        leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
      },
      window = {
        mappings = {
          ['<leader>`'] = 'close_window',
        },
      },
      filtered_items = {
        use_libuv_file_watcher = true,
        visible = false, -- show hidden files
        hide_dotfiles = false,
        hide_gitignored = false,
        hide_by_name = {
          'node_modules',
          '.cache',
          '.git',
          '.github',
        },
        always_show = { -- remains visible even if other settings would normally hide it
          '.gitignored',
          '.gitlab-ci.yml',
        },
        always_show_by_pattern = { -- uses glob style patterns
          '.env*',
        },
        never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
          '.DS_Store',
          'thumbs.db',
        },
      },
    },
  },
}
