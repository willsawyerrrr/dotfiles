-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    -- 'folke/snacks.nvim',
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
      -- {
      --   event = 'file_moved',
      --   handler = function(data)
      --     Snacks.rename.on_rename_file(data.source, data.destination)
      --   end,
      -- },
      -- {
      --   event = 'file_renamed',
      --   handler = function(data)
      --     Snacks.rename.on_rename_file(data.source, data.destination)
      --   end,
      -- },
      {
        event = 'file_added',
        handler = function(filepath)
          if vim.fn.isdirectory(filepath) == 0 then
            return
          end

          local languages_to_markers = {
            ['__init__.py'] = { 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt' },
            ['init.lua'] = { '.luarc.json', '.stylua.toml', 'init.lua' },
          }

          local function write_init_file(init_filename)
            local init_path = filepath .. '/' .. init_filename
            local f = io.open(init_path, 'w')
            if f then
              f:close()
            end
          end

          local cwd = vim.fn.getcwd()

          local written = false
          for init_filename, markers in pairs(languages_to_markers) do
            if written then
              break
            end
            for _, marker in ipairs(markers) do
              if vim.fn.filereadable(cwd .. '/' .. marker) == 1 then
                write_init_file(init_filename)
                written = true
                break
              end
            end
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
