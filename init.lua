-- init.lua
-- Bootstrap for modular Neovim config

-- Leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true

-- Load modules
require 'config.options'
require 'config.modern-apis' -- Load modern API fixes
require 'config.lazy' -- plugin manager & plugins
require 'config.autocmds'
require 'config.diagnostics'
require 'config.keymaps'
--require 'config.guess-indent' -- optional plugin config
