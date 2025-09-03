-- init.lua
-- Bootstrap for modular Neovim config

-- Leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true

-- Load modules
require 'config.options'
require 'config.keymaps'
require 'config.autocmds'
require 'config.lazy' -- plugin manager & plugins
require 'config.diagnostics'
--require 'config.guess-indent' -- optional plugin config
