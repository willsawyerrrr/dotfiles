vim.keymap.set('n', 'gG', function()
  local word = vim.fn.expand '<cWORD>'
  local repo = word:match '[%w%-%.]+/[%w%-%.]+'
  if not repo then
    vim.notify('No GitHub repo found under cursor', vim.log.levels.WARN)
    return
  end
  vim.ui.open('https://github.com/' .. repo)
end, { desc = 'Open GitHub repo under cursor' })
