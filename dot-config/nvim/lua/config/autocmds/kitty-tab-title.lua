vim.api.nvim_create_autocmd('VimEnter', {
  desc = 'Set kitty tab title',
  group = vim.api.nvim_create_augroup('set-kitty-tab-title', { clear = true }),
  callback = function()
    local cwd = vim.fn.getcwd()
    if cwd:match(vim.env.HOME) then
      cwd = cwd:sub(vim.env.HOME:len() + 2)
    end
    vim.o.title = true
    vim.o.titlestring = 'nvim: ' .. cwd
  end,
})
