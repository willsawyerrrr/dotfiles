return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  init = function()
    -- Homebrew's mermaid-cli doesn't ship a bundled Chromium, so point
    -- puppeteer at the system Chrome for snacks.image mermaid rendering.
    vim.env.PUPPETEER_EXECUTABLE_PATH = '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome'
  end,
  ---@module "snacks"
  ---@type snacks.Config
  opts = {
    gitbrowse = { enabled = true },
    image = {
      enabled = true,
      doc = {
        conceal = function(_, type)
          return type == 'math' or type == 'chart'
        end,
      },
    },
    indent = {
      -- Pretty indent lines
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
      chunk = {
        -- Code chunk. e.g Functions
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
