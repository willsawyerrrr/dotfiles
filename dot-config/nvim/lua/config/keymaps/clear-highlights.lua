-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', function()
  vim.cmd 'nohlsearch'
  vim.cmd 'NoiceDismiss'
  Snacks.notifier.hide()
end)
