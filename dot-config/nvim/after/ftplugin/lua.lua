-- Within this nvim configuration, override `K`: when the cursor is inside a
-- comment, run `:help! <cword>` (useful for references like `:h vim.lsp.config`
-- references in config comments); otherwise fall through to LSP hover.
-- Resolve symlinks so this works whether the buffer was opened via
-- `stdpath('config')` or via the underlying dotfiles dir.
local real_buf = vim.uv.fs_realpath(vim.api.nvim_buf_get_name(0))
local real_config = vim.uv.fs_realpath(vim.fn.stdpath 'config' .. '/init.lua')
if not (real_buf and real_config and vim.startswith(real_buf, vim.fs.dirname(real_config) .. '/')) then
  return -- Not in my NeoVim configuration
end

local function cursor_in_comment()
  local ok, node = pcall(vim.treesitter.get_node, { bufnr = 0 })
  if not ok then
    return false
  end
  while node do
    if node:type() == 'comment' then
      return true
    end
    node = node:parent()
  end
  return false
end

local function k_handler()
  if cursor_in_comment() then
    vim.cmd 'help!'
  else
    vim.lsp.buf.hover()
  end
end

local function set_mapping(bufnr)
  vim.keymap.set('n', 'K', k_handler, {
    buffer = bufnr,
    desc = ':help! in comments; LSP hover otherwise',
  })
end

-- Set immediately for the current buffer, and again on LspAttach so we win
-- against Neovim's default LSP `K` mapping if it lands after the ftplugin.
set_mapping(0)
vim.api.nvim_create_autocmd('LspAttach', {
  buffer = 0,
  callback = function(ev)
    set_mapping(ev.buf)
  end,
})
