return {
  'nvim-telescope/telescope.nvim',
  event = 'VimEnter',
  dependencies = {
    'nvim-lua/plenary.nvim',
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
    { 'nvim-telescope/telescope-ui-select.nvim' },
    { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
  },
  config = function()
    -- Two important keymaps to use while in Telescope are:
    --  - Insert mode: <c-/>
    --  - Normal mode: ?
    --
    -- This opens a window that shows you all of the keymaps for the current
    -- Telescope picker. This is really useful to discover what Telescope can
    -- do as well as how to actually do it!

    require('telescope').setup {
      extensions = {

        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = 'smart_case',
        },
        ['ui-select'] = {
          require('telescope.themes').get_dropdown(),
        },
      },
      pickers = {
        colorscheme = {
          enable_preview = true,
        },
        find_files = {
          find_command = { 'rg', '--files', '--hidden', '--glob', '!**/.git/*' },
        },
        live_grep = {
          search_dirs = { '.', '!.git', '.github' },
        },
      },
    }

    require('telescope').load_extension 'fzf'
    require('telescope').load_extension 'ui-select'

    local builtin = require 'telescope.builtin'
    vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
    vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
    vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
    vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
    vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
    vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
    vim.keymap.set('n', '<leader>sq', builtin.quickfix, { desc = '[S]earch [Q]uickfix' })
    vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
    vim.keymap.set('n', '<leader>ss', builtin.lsp_document_symbols, { desc = '[S]earch Document [S]ymbols' })
    vim.keymap.set('n', '<leader>st', builtin.builtin, { desc = '[S]earch [T]elescope Pickers' })
  end,
}
