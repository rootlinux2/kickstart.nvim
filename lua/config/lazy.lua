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
require('lazy').setup {
  -- FTerm
  {
    'numToStr/FTerm.nvim',
    opts = {
      border = 'rounded',
      dimensions = { height = 0.8, width = 0.8 },
    },
    config = function(_, opts)
      require('FTerm').setup(opts)
      vim.api.nvim_create_autocmd('TermOpen', {
        pattern = 'FTerm_*',
        callback = function(args)
          vim.bo[args.buf].modifiable = true
        end,
      })
      vim.keymap.set('n', '<leader>t', ':lua require("FTerm").toggle()<CR>', { desc = 'Toggle floating terminal' })
    end,
  },

  -- Which Key
  {
    'folke/which-key.nvim',
    event = 'VimEnter',
    opts = {
      delay = 0,
      icons = { mappings = vim.g.have_nerd_font },
      spec = {
        { '<leader>s', group = '[S]earch' },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
        { '<leader>d', group = '[D]ebug' },
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

      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
    end,
  },

  --  Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  { import = 'kickstart.plugins' }, -- Import plugins from the custom directory
  { import = 'custom.plugins' }, -- Import plugins from the custom directory
  --
}
