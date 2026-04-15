return {
  -- Highlight, edit, and navigate code
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  build = ':TSUpdate',
  branch = 'main',
  dependencies = {
    { 'nvim-treesitter/nvim-treesitter-textobjects', branch = 'main' },
  },
  -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
  opts = {
    textobjects = {
      lsp_interop = {
        enable = true,
        peek_definition_code = {
          ['<leader>df'] = '@function.outer',
        },
      },
      select = {
        enable = true,
        keymaps = {
          ['ac'] = '@class.outer',
          ['ic'] = '@class.inner',
          ['af'] = '@function.outer',
          ['if'] = '@function.inner',
        },
      },
    },
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

  -- There are additional nvim-treesitter modules that you can use to interact
  -- with nvim-treesitter. You should go explore a few and see what interests you:
  --
  --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
  --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
  --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
}
