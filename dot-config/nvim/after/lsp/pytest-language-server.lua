local pytest_lsp_name = 'pytest_lsp'
vim.lsp.config(pytest_lsp_name, {
  cmd = { 'pytest-language-server' },
  filetypes = { 'python' },
  root_markers = {
    'pyproject.toml',
    'setup.py',
    'setup.cfg',
    'pytest.ini',
    '.git',
  },
  settings = {},
})
vim.lsp.enable(pytest_lsp_name)
