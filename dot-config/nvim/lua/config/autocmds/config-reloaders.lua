vim.api.nvim_create_autocmd('BufWritePost', {
  desc = 'Regenerate AeroSpace config from source and reload',
  pattern = vim.uv.fs_realpath(vim.fn.expand '~' .. '/dotfiles/dot-config/aerospace/aerospace.source.toml'),
  callback = function()
    local out = vim.fn.system 'task -d ~/dotfiles aerospace:gen stow:install && aerospace reload-config && sketchybar --reload'
    if vim.v.shell_error ~= 0 then
      vim.notify('AeroSpace regen/reload failed:\n' .. out, vim.log.levels.ERROR)
    else
      vim.notify('AeroSpace config regenerated and reloaded', vim.log.levels.INFO)
    end
  end,
})

vim.api.nvim_create_autocmd('BufWritePost', {
  desc = 'Auto-reload Kitty config',
  pattern = vim.fn.expand '~' .. '/.config/kitty/kitty.conf',
  command = ':silent !kill -SIGUSR1 $KITTY_PID',
})
