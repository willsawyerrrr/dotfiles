local M = {}

---Requires all Lua modules (except for `init.lua`) in the given directory
---
---@param path string Path relative to the root of the nvim configuration directory
---@param require_prefix string Prefix for the require string
function M.require_all(path, require_prefix)
  for _, path in ipairs(vim.fn.glob(vim.fn.stdpath 'config' .. path .. '/*.lua', false, true)) do
    local name = vim.fn.fnamemodify(path, ':t:r')

    if name ~= 'init' then
      require(require_prefix .. name)
    end
  end
end

return M
