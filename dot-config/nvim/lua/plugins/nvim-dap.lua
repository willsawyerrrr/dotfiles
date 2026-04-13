return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'rcarriga/nvim-dap-ui',
    'theHamsta/nvim-dap-virtual-text',
    'nvim-neotest/nvim-nio',
    'mason-org/mason.nvim',
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    dap.adapters.debugpy = {
      type = 'executable',
      command = 'python',
      args = { '-m', 'debugpy.adapter' },
    }
    dap.adapters.python = dap.adapters.debugpy

    vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint)
    vim.keymap.set('n', '<leader>B', function()
      dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
    end)

    -- TODO: Figure out DAP keymaps to not pollute
    -- vim.keymap.set('n', '<F>', dap.continue)
    -- vim.keymap.set('n', '<F>', dap.step_into)
    -- vim.keymap.set('n', '<F>', dap.step_over)
    -- vim.keymap.set('n', '<F>', dap.step_out)
    -- vim.keymap.set('n', '<F>', dap.step_back)
    -- vim.keymap.set('n', '<F>', dap.restart)

    dapui.setup {
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
    }

    dap.listeners.after.event_initialized.dapui_config = dapui.open
    dap.listeners.before.attach.dapui_config = dapui.open
    dap.listeners.before.launch.dapui_config = dapui.open
    dap.listeners.before.event_terminated.dapui_config = dapui.close
    dap.listeners.before.event_exited.dapui_config = dapui.close

    -- Toggle to see last session result.
    -- Without this, you can't see session output in case of unhandled exception.
    vim.keymap.set('n', '<F7>', dapui.toggle, { desc = 'Debug: See last session result.' })
  end,
}
