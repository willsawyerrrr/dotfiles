return {
  'nvim-neotest/neotest',
  dependencies = {
    'nvim-neotest/neotest-python',
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
  },
  opts = {
    adapters = {
      ['neotest-python'] = {
        runner = 'pytest',
      },
    },
  },
  config = function()
    local neotest = require 'neotest'

    ---@diagnostic disable-next-line: missing-fields
    neotest.setup {
      adapters = {
        require 'neotest-python' {
          dap = { justMyCode = false },
          args = { '--log-level', 'DEBUG' },
          python = '.venv/bin/python',
        },
      },
    }

    vim.keymap.set('n', '<leader>ts', neotest.summary.open, { desc = 'NeoTest: Open test summary' })
    vim.keymap.set('n', '<leader>to', neotest.output_panel.open, { desc = 'NeoTest: Open test output panel' })
    vim.keymap.set('n', '<leader>tt', neotest.run.run, { desc = 'NeoTest: Run single test' })
    vim.keymap.set('n', '<leader>tf', function()
      neotest.run.run(vim.fn.expand '%')
    end, { desc = 'NeoTest: Run entire file' })
    vim.keymap.set('n', '<leader>td', function()
      neotest.run.run { strategy = 'dap' }
    end, { desc = 'NeoTest: Debug test' })
    vim.keymap.set('n', '<leader>tD', function()
      neotest.run.run { vim.fn.expand '%', strategy = 'dap' }
    end, { desc = 'NeoTest: Debug entire file' })
  end,
}
