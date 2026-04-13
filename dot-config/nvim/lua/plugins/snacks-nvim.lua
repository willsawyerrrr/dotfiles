return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  ---@module "snacks"
  ---@type snacks.Config
  opts = {
    gitbrowse = { enabled = true },
    image = { enabled = true },
    indent = { -- Pretty indent lines
      enabled = true,
      indent = {
        char = '┊',
      },
      animate = {
        enabled = false,
      },
      scope = {
        hl = 'Comment',
      },
      chunk = { -- Code chunk. e.g Functions
        enabled = true,
        hl = 'Comment',
        char = {
          corner_top = '╭',
          corner_bottom = '╰',

          horizontal = '─',
          vertical = '│',
          arrow = '',
        },
      },
    },
    input = {
      enabled = true,
    },
    notifier = {
      enabled = true,
      top_down = false,
    },
    scroll = {},
  },
  keys = {
    {
      'gb',
      function()
        Snacks.gitbrowse()
      end,
      desc = 'GitBrowse',
    },
  },
}
