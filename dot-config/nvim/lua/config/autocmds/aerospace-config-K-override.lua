-- In aerospace.source.toml, map K to open the aerospace-<cmd>(1) man page
-- for the word under the cursor. Prevents the need for per-command doc-URL
-- comments. K on a non-existent command falls through to :Man's own "no
-- manual entry" error.

vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  desc = 'aerospace.source.toml: map K to aerospace-<cmd>(1) for the word under cursor',
  group = vim.api.nvim_create_augroup('aerospace-config-K-override', { clear = true }),
  pattern = '*/aerospace/aerospace.source.toml',
  callback = function(args)
    -- Override K (rather than using keywordprg) so it fires regardless of `:h iskeyword`.
    vim.keymap.set('n', 'K', function()
      -- <cWORD> is whitespace-delimited, so it captures the full quoted token
      -- including hyphens; strip down to the letters/digits/hyphens run.
      -- <cword> stops at the first hyphen, which would truncate compound
      -- command names like `macos-native-fullscreen`.
      local command = vim.fn.expand('<cWORD>'):match '[%w%-]+'
      if not command then
        vim.notify('No command word under cursor', vim.log.levels.WARN)
        return
      end
      vim.cmd('Man aerospace-' .. command)
    end, { buffer = args.buf, desc = 'Open aerospace-<cmd>(1) for word under cursor' })
  end,
})
