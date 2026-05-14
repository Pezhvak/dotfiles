return {
  'rebelot/kanagawa.nvim',
  name = 'kanagawa',
  lazy = true,
  opts = {
    compile = false,
    transparent = true,
    dimInactive = false,
    terminalColors = true,
    theme = 'wave', -- wave, dragon, lotus
    background = {
      dark = 'wave',
      light = 'lotus',
    },
    colors = {
      theme = {
        all = {
          ui = { bg_gutter = 'none' },
        },
      },
    },
  },
}
