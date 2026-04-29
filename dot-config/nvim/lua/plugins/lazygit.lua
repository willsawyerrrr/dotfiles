return {
  'kdheepak/lazygit.nvim',
  lazy = true,
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  keys = {
    { '<leader>lg', '<cmd>LazyGit<cr>', desc = 'LazyGit' },
  },
}
