-- init.lua
-- Bootstrap for modular Neovim config

-- Leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true

-- Load modules
require 'config.options'
require 'config.lazy' -- plugin manager & plugins
require 'config.autocmds'
require 'config.diagnostics'
require 'config.keymaps'
--require 'config.guess-indent' -- optional plugin config

-- Enable terminal title updates
vim.o.title = true

-- Define a global Lua function
_G.project_name = function()
  local cwd = vim.fn.getcwd()
  return vim.fn.fnamemodify(cwd, ':t')
end

-- Use the global function in the title
vim.o.titlestring = '%{v:lua.project_name()} - nvim'

-- Check Yazi availability on startup
vim.defer_fn(function()
  require('config.yazi-setup').setup()
end, 100)
