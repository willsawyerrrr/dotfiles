-- Set <space> as the leader key
--  Must happen before plugins are loaded otherwise wrong leader will be used
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require 'config.lazy'
require 'config.autocmds'
require 'config.options'
require 'config.keymaps'

-- See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
