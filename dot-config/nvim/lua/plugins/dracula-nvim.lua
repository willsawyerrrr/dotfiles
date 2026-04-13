return {
  'maxmx03/dracula.nvim',
  dependencies = {
    'nvim-lualine/lualine.nvim',
  },
  lazy = false,
  priority = 1000,
  config = function()
    require('dracula').setup {
      styles = {
        Type = {},
        Function = {},
        Parameter = {},
        Property = {},
        Comment = {},
        String = {},
        Keyword = {},
        Identifier = {},
        Constant = {},
      },
      transparent = true,
      on_colors = function(colors, color)
        ---@type dracula.palette
        return {
          -- override or create new colors
          mycolor = '#ffffff',
          -- mycolor = 0xffffff,
        }
      end,
      on_highlights = function(colors, color)
        ---@type dracula.highlights
        return {
          ---@type vim.api.keyset.highlight
          Normal = { fg = colors.mycolor },
        }
      end,
      plugins = {
        ['bufferline.nvim'] = true,
        ['dashboard-nvim'] = true,
        ['gitsigns.nvim'] = true,
        ['hop.nvim'] = true,
        ['indent-blankline.nvim'] = true,
        ['lazy.nvim'] = true,
        ['mini.cursorword'] = true,
        ['mini.starter'] = true,
        ['mini.statusline'] = true,
        ['mini.tabline'] = true,
        ['neo-tree.nvim'] = true,
        ['neogit'] = true,
        ['noice.nvim'] = true,
        ['nvim-cmp'] = true,
        ['nvim-lspconfig'] = true,
        ['nvim-navic'] = true,
        ['nvim-tree.lua'] = true,
        ['nvim-treesitter'] = true,
        ['rainbow-delimiters'] = true,
        ['telescope.nvim'] = true,
        ['todo-comments.nvim'] = true,
        ['which-key.nvim'] = true,
      },
    }
    vim.cmd.colorscheme 'dracula'
    vim.cmd.colorscheme 'dracula-soft'
  end,
}
