# `after/lsp/`

Per-server LSP overrides. Each file is named after its lspconfig server name
(e.g. `lua_ls.lua`, `bashls.lua`) and `return`s a `:h vim.lsp.Config` table.

Neovim auto-discovers these files via the runtime path and deep-merges them on
top of nvim-lspconfig's bundled defaults, so you only need to specify the keys
you want to override — `cmd`, `root_markers`, etc. fall through.

Servers listed here are also what gets enabled and installed: `lua/plugins/nvim-lspconfig.lua`
globs this directory, hands the basenames to `mason-tool-installer`'s `ensure_installed`, and
calls `vim.lsp.enable(...)` on each.

To add a new server: create `<server_name>.lua` here returning at least `{}`.
See `:help lspconfig-all` for the full list of pre-configured servers and their
expected names.

## Opting out of Mason

By default every file here is added to `mason-tool-installer`'s
`ensure_installed`. To exclude a server (e.g. one installed outside Mason, like
a locally-built binary), set `mason = false` on the returned table:

```lua
return {
  mason = false,
  cmd = { 'pytest-language-server' },
  ...
}
```

The field is ignored by Neovim's LSP config resolver — it's only read by the
plugin's glob loop.
