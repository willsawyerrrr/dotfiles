vim.api.nvim_create_autocmd('BufWritePost', {
  desc = 'Auto-reload AeroSpace config',
  pattern = vim.uv.fs_realpath(vim.fn.expand '~' .. '/.config/aerospace/aerospace.toml'),
  command = ':silent !aerospace reload-config',
})

vim.api.nvim_create_autocmd('BufWritePost', {
  desc = 'Auto-reload Kitty config',
  pattern = vim.fn.expand '~' .. '/.config/kitty/kitty.conf',
  command = ':silent !kill -SIGUSR1 $KITTY_PID',
})
