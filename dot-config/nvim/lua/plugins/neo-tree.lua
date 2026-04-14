-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'MunifTanjim/nui.nvim',
  },
  lazy = false,
  keys = {
    { '\\', ':Neotree reveal<CR>', desc = 'Open NeoTree', silent = true },
    { '<leader>ds', ':Neotree document_symbols<CR>', desc = 'Open document symbols', silent = true },
  },
  ---@module 'neo-tree'
  ---@type neotree.Config
  opts = {
    auto_clean_after_session_restore = true,
    close_if_last_window = true,
    enable_cursor_hijack = true,
    popup_border_style = '',
    sort_case_insensitive = true,

    sources = {
      'filesystem',
      'document_symbols',
    },

    document_symbols = {
      follow_cursor = true,
    },

    event_handlers = {
      {
        event = 'neo_tree_buffer_enter',
        handler = function()
          vim.opt_local.number = true -- Optional: ensure absolute numbers are also shown
          vim.opt_local.relativenumber = true
        end,
      },
      {
        event = 'file_added',
        handler = function(filepath)
          if vim.fn.isdirectory(filepath) == 0 then
            return
          end

          local cwd = vim.fn.getcwd()
          local python_markers = { 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt' }
          local is_python = false
          for _, marker in ipairs(python_markers) do
            if vim.fn.filereadable(cwd .. '/' .. marker) == 1 then
              is_python = true
              break
            end
          end

          if not is_python then
            return
          end

          local init_path = filepath .. '/__init__.py'
          local f = io.open(init_path, 'w')
          if f then
            f:close()
          end
        end,
      },
    },

    filesystem = {
      filtered_items = {
        hide_dotfiles = false,
        hide_gitignored = true,
        hide_ignored = false,
      },

      commands = {
        ---@module 'neo-tree.sources.common.node_expander'
        ---@module 'nui.tree'
        ---@type neotree.TreeCommandNormal
        delete = function(state, callback)
          local node = assert(state.tree:get_node())
          if node.type ~= 'file' and node.type ~= 'directory' then
            return
          end
          if node:get_depth() == 1 then
            return
          end
          require('neo-tree.sources.filesystem.lib.fs_actions').delete_node(node.path, callback, true)
        end,
      },

      window = {
        use_default_mappings = false,
        mappings = {
          ['?'] = {
            'show_help',
            desc = 'Show help',
          },
          ['\\'] = {
            'close_window',
            desc = 'Close window',
          },
          ['<cr>'] = {
            'open',
            desc = 'Open file',
          },
          ['d'] = {
            'delete',
            config = {},
            desc = 'Delete file or directory',
          },
          ['n'] = {
            'add',
            desc = 'Create new file',
          },
          ['p'] = {
            'toggle_preview',
            config = {
              use_float = false,
            },
          },
          ['P'] = {
            'paste_from_clipboard',
          },
          ['r'] = {
            'rename',
            desc = 'Rename file or directory',
          },
        },
      },
    },
  },
}
