return {
  'greggh/claude-code.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  config = function()
    require('claude-code').setup {
      window = {
        position = 'float',
        float = {
          width = '90%', -- Take up 90% of the editor width
          height = '90%', -- Take up 90% of the editor height
        },
      },
    }
  end,
  keys = {
    { '<leader>cc', '<cmd>ClaudeCodeContinue<cr>', desc = 'Claude Code' },
  },
}
