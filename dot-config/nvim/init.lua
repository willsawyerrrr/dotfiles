-- Set <space> as the leader key
--  Must happen before plugins are loaded otherwise wrong leader will be used
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require 'config.options'
require 'config.autocmds'
require 'config.keymaps'
require 'config.lazy'

-- See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
