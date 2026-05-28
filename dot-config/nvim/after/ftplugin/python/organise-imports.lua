-- Organise imports using Ruff on write
vim.api.nvim_create_autocmd('BufWritePost', {
  buffer = 0,
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
