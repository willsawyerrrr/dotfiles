return {
  'andythigpen/nvim-coverage',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },

  config = function()
    require('coverage').setup {
      auto_reload = true,
    }
  end,
}
