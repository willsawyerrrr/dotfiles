return {
  'greggh/claude-code.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  cmd = { 'ClaudeCode', 'ClaudeCodeContinue', 'ClaudeCodePrompt' },
  opts = {
    window = {
      position = 'float',
      float = {
        width = '90%', -- Take up 90% of the editor width
        height = '90%', -- Take up 90% of the editor height
      },
    },
  },
  keys = {
    { '<leader>cc', '<cmd>ClaudeCodeContinue<cr>', desc = 'Claude Code' },
  },
  config = function(_, opts)
    require('claude-code').setup(opts)

    vim.api.nvim_create_user_command('ClaudeCodePrompt', function(o)
      if o.args == '' then
        vim.notify('ClaudeCodePrompt requires a prompt argument', vim.log.levels.ERROR)
        return
      end
      local prompt = o.args

      vim.cmd 'ClaudeCode'
      local bufnr = vim.api.nvim_get_current_buf()

      vim.defer_fn(function()
        local chan = vim.b[bufnr].terminal_job_id
        if not chan then
          vim.notify('Claude Code terminal not ready', vim.log.levels.ERROR)
          return
        end
        vim.api.nvim_chan_send(chan, prompt)
        vim.defer_fn(function()
          vim.api.nvim_chan_send(chan, '\r')
        end, 100)
      end, 500)
    end, {
      nargs = '+',
      desc = 'Open Claude Code and run the given prompt',
    })
  end,
}
