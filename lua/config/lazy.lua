-- Bootstrap Lazy.nvim
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    '--branch=stable',
    'https://github.com/folke/lazy.nvim.git',
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- Plugins
require('lazy').setup({
  -- Which Key
  {
    'folke/which-key.nvim',
    event = 'VimEnter',
    opts = {
      delay = 0,
      icons = { mappings = vim.g.have_nerd_font },
      spec = {
        { '<leader>s', group = '[S]earch' },
        { '<leader>t', group = '[T]abs' },
        { '<leader>z', group = 'Folding' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
        { '<leader>g', group = '[G]it' },
        { '<leader>gb', group = 'Git [B]ranches' },
        { '<leader>gc', group = 'Git [C]ommit/Conflict' },
        { '<leader>gd', group = 'Git [D]iff' },
        { '<leader>gf', group = 'Git [F]ilter' },
        { '<leader>gw', group = 'Git [W]orktree' },
        { '<leader>d', group = '[D]ebug' },
        { '<leader>n', group = '[N]ode.js/NPM' },
        { '<leader>y', group = '[Y]arn' },
        { '<leader>r', group = '[R]EST/API' },
        { '<leader>c', group = '[C]opilot' },
        { '<leader>cc', group = 'Copilot [C]hat' },
        { '<leader>x', group = 'Trouble/Todo' },
        { '<leader>f', desc = '[F]ormat buffer' },
      },
    },
  },

  -- Telescope
  {
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
      'nvim-telescope/telescope-ui-select.nvim',
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      local telescope = require 'telescope'
      telescope.setup {
        defaults = { file_ignore_patterns = { 'node_modules', '%.git/', 'dist' } },
        extensions = { ['ui-select'] = require('telescope.themes').get_dropdown() },
      }
      pcall(telescope.load_extension, 'fzf')
      pcall(telescope.load_extension, 'lazygit')
      pcall(telescope.load_extension, 'ui-select')
    end,
  },

  --  Import plugins from directories
  { import = 'kickstart.plugins' }, -- Import plugins from kickstart directory
  { import = 'custom.plugins' }, -- Import plugins from the custom directory
}, {
  -- Lazy.nvim configuration options
  checker = { 
    enabled = false, -- Don't automatically check for updates
    notify = false 
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
