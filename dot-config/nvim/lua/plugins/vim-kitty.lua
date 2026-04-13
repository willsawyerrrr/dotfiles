return {
  'fladson/vim-kitty',
  ft = 'kitty',

  config = function()
    vim.api.nvim_create_autocmd('BufWritePost', {
      pattern = vim.fn.expand '~' .. '/.config/kitty/kitty.conf',
      command = ':silent !kill -SIGUSR1 $KITTY_PID',
    })
  end,
}
