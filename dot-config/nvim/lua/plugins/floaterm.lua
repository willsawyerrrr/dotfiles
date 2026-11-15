return {
  'nvzone/floaterm',
  dependencies = 'nvzone/volt',
  opts = {
    border = true,
    size = { h = 85, w = 90 },

    terminals = {
      { name = 'Claude Code', cmd = 'claude' },
      { name = 'Lazygit', cmd = 'lazygit' },
    },
  },
  cmd = 'FloatermToggle',
  keys = {
    { '<leader>,', '<cmd>FloatermToggle<cr>', mode = { 'n', 'x', 'o', 't' }, desc = 'Toggle floaterm' },
  },
}
