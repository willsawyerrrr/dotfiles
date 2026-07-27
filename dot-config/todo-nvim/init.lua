-- Minimal profile for the floating todo-list window (NVIM_APPNAME=todo-nvim).
-- No plugin manager, no LSP — just enough to view and edit a markdown checklist.
-- The dracula.nvim colorscheme is vendored as a native package under pack/vendor/start/.

require('dracula').setup { transparent = true }
vim.cmd.colorscheme 'dracula-soft'

vim.opt.number = false
vim.opt.relativenumber = false
vim.opt.signcolumn = "no"
vim.opt.laststatus = 0
vim.opt.showtabline = 0
vim.opt.ruler = false
vim.opt.title = false
vim.opt.wrap = true
vim.opt.breakindent = true
vim.opt.linebreak = true
vim.opt.conceallevel = 2
vim.opt.swapfile = false
vim.opt.undofile = false
vim.opt.backup = false

-- Toggle a `- [ ]`/`- [x]` checkbox on the current line.
vim.keymap.set("n", "<CR>", function()
  local line = vim.api.nvim_get_current_line()
  local toggled = line:find("%[ %]") and line:gsub("%[ %]", "[x]", 1) or line:gsub("%[x%]", "[ ]", 1)
  vim.api.nvim_set_current_line(toggled)
end, { desc = "Toggle todo checkbox" })

vim.api.nvim_create_autocmd({ "TextChanged", "InsertLeave" }, {
  pattern = "*",
  command = "silent! write",
})

-- kitty's quick-access-terminal panel doesn't render OS-level window borders,
-- so draw one ourselves by re-opening the buffer in a bordered floating window
-- that covers the whole terminal, leaving the real window blank behind it.
vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = function()
    local file_buf = vim.api.nvim_get_current_buf()
    local base_win = vim.api.nvim_get_current_win()

    vim.api.nvim_open_win(file_buf, true, {
      relative = "editor",
      width = vim.o.columns - 2,
      height = vim.o.lines - 2,
      row = 1,
      col = 1,
      border = "rounded",
      style = "minimal",
    })
    vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#bd93f9" })

    vim.api.nvim_win_set_buf(base_win, vim.api.nvim_create_buf(false, true))
  end,
})
