return {
  settings = {
    Lua = {
      completion = {
        callSnippet = 'Replace',
      },
      workspace = {
        checkThirdParty = true,
        library = {
          vim.env.VIMRUNTIME,
          '~/.local/share/nvim/lazy/dracula.nvim',
        },
      },
    },
  },
}
