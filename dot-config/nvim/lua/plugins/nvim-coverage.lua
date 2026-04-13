return {
  'andythigpen/nvim-coverage',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },

  version = '*',
  config = function()
    require('coverage').setup {
      auto_reload = true,
    }
  end,
}
