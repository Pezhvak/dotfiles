return {
  'catppuccin/nvim',
  name = 'catppuccin',
  lazy = true,
  opts = {
    flavour = 'mocha', -- latte, frappe, macchiato, mocha
    transparent_background = true,
    float = { transparent = true, solid = false },
    term_colors = true,
    styles = {
      comments = { 'italic' },
      keywords = { 'italic' },
    },
    integrations = {
      cmp = true,
      gitsigns = true,
      treesitter = true,
      notify = true,
      mini = { enabled = true },
      telescope = { enabled = true },
    },
  },
}
