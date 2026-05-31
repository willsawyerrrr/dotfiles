--  See `:help lua-guide-autocommands`

for _, path in ipairs(vim.fn.glob(vim.fn.stdpath 'config' .. '/lua/config/autocmds/*.lua', false, true)) do
  local name = vim.fn.fnamemodify(path, ':t:r')

  if name ~= 'init' then
    require('config.autocmds.' .. name)
  end
end
