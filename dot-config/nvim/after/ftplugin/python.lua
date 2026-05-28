vim.cmd 'iabbrev <buffer> improt import'

-- Yank Inner Word, go to End of word, Append " as ", Esc to normal mode, Paste
vim.keymap.set('n', '<leader>ia', 'yiwea as <Esc>p', { buffer = true, desc = 'Append redundant alias for word under cursor' })

-- Organise imports using Ruff on write
vim.api.nvim_create_autocmd('BufWritePost', {
  callback = function()
    vim.lsp.buf.code_action {
      context = {
        only = { 'source.organizeImports' },
        diagnostics = {},
      },
      apply = true,
    }
  end,
})
