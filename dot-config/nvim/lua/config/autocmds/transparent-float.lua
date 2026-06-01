-- Ensure that floating windows are transparent too.
-- Re-applied on ColorScheme so it survives colorscheme loads/reloads that
-- would otherwise overwrite NormalFloat/FloatBorder backgrounds.
vim.api.nvim_create_autocmd('ColorScheme', {
  desc = 'Make floating windows transparent',
  group = vim.api.nvim_create_augroup('transparent-float', { clear = true }),
  callback = function()
    vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'NONE', ctermbg = 'NONE' })
    vim.api.nvim_set_hl(0, 'FloatBorder', { bg = 'NONE', ctermbg = 'NONE' })
  end,
})
