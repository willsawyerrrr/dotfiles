-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', function()
  vim.cmd 'nohlsearch'
  vim.cmd 'NoiceDismiss'
  Snacks.notifier.hide()
end)

vim.keymap.set('n', '<leader>w', '<cmd>write<CR>', { desc = 'Write file' })
vim.keymap.set('n', '<leader>q', '<cmd>quit<CR>', { desc = 'Quit' })

vim.keymap.set('n', 'gh', 'viWK', { desc = 'Get help for word' })

vim.keymap.set('n', 'gG', function()
  local word = vim.fn.expand '<cWORD>'
  local repo = word:match '[%w%-%.]+/[%w%-%.]+'
  if not repo then
    vim.notify('No GitHub repo found under cursor', vim.log.levels.WARN)
    return
  end
  vim.ui.open('https://github.com/' .. repo)
end, { desc = 'Open GitHub repo under cursor' })

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>f', vim.diagnostic.setloclist, { desc = 'Open diagnostic quick[F]ix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc.
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Disable arrow keys in normal mode
vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- TODO: How can I make opening delimeters wrap a selection?
-- vim.keymap.set('v', '(', 'sa(')
-- vim.keymap.set('v', '[', 'sa]')
-- vim.keymap.set('v', '{', 'sa}')
-- vim.keymap.set('v', '"', 'sa"')
-- vim.keymap.set('v', "'", "sa'")
