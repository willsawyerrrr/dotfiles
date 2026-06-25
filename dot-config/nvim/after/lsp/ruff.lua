-- Prefer a project-local `ruff` (e.g. from the active virtualenv) over the
-- Mason-installed one, so the editor matches whatever the project pins. Falls
-- back to `ruff` on $PATH, which Mason prepends its bin dir to.
local function ruff_cmd()
  local root = vim.fs.root(0, { 'pyproject.toml', 'ruff.toml', '.ruff.toml', '.git' }) or vim.fn.getcwd()
  local candidate = root .. '/.venv/bin/ruff'
  if vim.fn.executable(candidate) == 1 then
    return { candidate, 'server' }
  end
  return { 'ruff', 'server' }
end

return {
  cmd = ruff_cmd(),
}
