vim.cmd 'iabbrev <buffer> improt import'

-- Yank Inner Word, go to End of word, Append " as ", Esc to normal mode, Paste
vim.keymap.set('n', '<leader>ia', 'yiwea as <Esc>p', { buffer = true, desc = 'Append redundant alias for word under cursor' })
