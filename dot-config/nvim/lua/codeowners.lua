-- Resolve the current buffer's GitHub CODEOWNERS via the `codeowners` CLI
-- (hmarr/codeowners), which implements the full gitignore-style matching spec.
-- The result is cached on the buffer; the CLI is only invoked once per buffer.

local M = {}

---@return string owners space-separated, or empty string when unowned/unavailable
local function compute()
  if vim.fn.executable 'codeowners' == 0 then
    return ''
  end

  local file = vim.api.nvim_buf_get_name(0)
  if file == '' or vim.fn.filereadable(file) == 0 then
    return ''
  end

  local git = vim.fs.find('.git', { path = file, upward = true })[1]
  if not git then
    return ''
  end
  local root = vim.fs.dirname(git)
  local rel = file:sub(#root + 2) -- path relative to root, no leading slash

  local result = vim.system({ 'codeowners', '--', rel }, { cwd = root, text = true }):wait()
  if result.code ~= 0 then
    return ''
  end

  local line = vim.split(result.stdout or '', '\n', { trimempty = true })[1]
  if not line then
    return ''
  end

  -- Output is "<rel><padding><owners>"; strip the known path prefix.
  local owners = vim.trim(line:sub(#rel + 1))
  if owners == '' or owners == '(unowned)' then
    return ''
  end
  return owners
end

---Owners for the current buffer, cached on the buffer.
---@return string
function M.get_codeowners()
  if vim.b.codeowners == nil then
    vim.b.codeowners = compute()
  end
  return vim.b.codeowners
end

return M
