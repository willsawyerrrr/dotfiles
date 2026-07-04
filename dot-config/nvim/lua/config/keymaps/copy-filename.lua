vim.keymap.set('n', '<leader>yf', function()
  local filename = vim.fn.expand '%:.'
  if filename == '' then
    vim.notify('No file name for current buffer', vim.log.levels.WARN)
    return
  end
  vim.fn.setreg('+', filename)
  vim.notify('Copied ' .. filename .. ' to clipboard')
end, { desc = '[Y]ank current [F]ile name to clipboard' })
