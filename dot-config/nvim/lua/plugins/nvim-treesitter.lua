return {
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  build = ':TSUpdate',
  branch = 'main',
  dependencies = {
    { 'nvim-treesitter/nvim-treesitter-textobjects', branch = 'main' },
  },

  init = function()
    local ensure_installed = {
      'bash',
      'diff',
      'dockerfile',
      'git_config',
      'hcl',
      'html',
      'javascript',
      'jq',
      'json',
      'jsx',
      'kitty',
      'lua',
      'luadoc',
      'markdown',
      'markdown_inline',
      'python',
      'query',
      'terraform',
      'toml',
      'typescript',
      'vim',
      'vimdoc',
      'yaml',
      'zsh',
    }
    local already_installed = require('nvim-treesitter.config').get_installed()
    local parsers_to_install = vim
      .iter(ensure_installed)
      :filter(function(parser)
        return not vim.tbl_contains(already_installed, parser)
      end)
      :totable()
    require('nvim-treesitter').install(parsers_to_install)

    vim.api.nvim_create_autocmd('FileType', {
      callback = function()
        pcall(vim.treesitter.start)
      end,
      desc = 'Enable treesitter highlighting',
    })

    vim.api.nvim_create_autocmd('FileType', {
      callback = function()
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
      desc = 'Enable treesitter-based indentation',
    })
  end,
}
