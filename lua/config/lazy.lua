-- Bootstrap Lazy.nvim
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
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
  -- FTerm - Modern floating terminal
  {
    'numToStr/FTerm.nvim',
    keys = {
      { '<leader>t', desc = 'Toggle floating terminal' },
      { '<C-\\>', desc = 'Toggle floating terminal' },
    },
    opts = {
      border = 'rounded',
      dimensions = { 
        height = 0.8, 
        width = 0.8,
        x = 0.5,
        y = 0.5 
      },
      blend = 0,
      auto_close = true,
    },
    config = function(_, opts)
      require('FTerm').setup(opts)
      
      -- Enhanced terminal autocmds
      vim.api.nvim_create_autocmd('TermOpen', {
        group = vim.api.nvim_create_augroup('FTermSetup', { clear = true }),
        pattern = 'term://*FTerm*',
        callback = function(args)
          local buf = args.buf
          vim.bo[buf].buflisted = false
          vim.wo.number = false
          vim.wo.relativenumber = false
          vim.wo.signcolumn = 'no'
          vim.wo.statuscolumn = ''
          
          -- Enter insert mode automatically
          vim.cmd('startinsert')
        end,
      })
      
      -- Better terminal closing behavior
      vim.api.nvim_create_autocmd('TermClose', {
        group = vim.api.nvim_create_augroup('FTermClose', { clear = true }),
        pattern = 'term://*FTerm*',
        callback = function()
          vim.schedule(function()
            vim.cmd('bdelete!')
          end)
        end,
      })
      
      -- Multiple terminal instances
      local terminals = {}
      
      local function create_terminal_toggle(id, cmd)
        return function()
          if not terminals[id] then
            terminals[id] = require('FTerm'):new({
              cmd = cmd,
              dimensions = opts.dimensions,
            })
          end
          terminals[id]:toggle()
        end
      end
      
      -- Keymaps with enhanced functionality
      vim.keymap.set({'n', 't'}, '<leader>t', function()
        require('FTerm').toggle()
      end, { desc = 'Toggle floating terminal' })
      
      vim.keymap.set({'n', 't'}, '<C-\\>', function()
        require('FTerm').toggle()
      end, { desc = 'Toggle floating terminal' })
      
      -- Additional terminal types
      vim.keymap.set('n', '<leader>tg', create_terminal_toggle('git', 'lazygit'), { desc = 'Toggle LazyGit terminal' })
      vim.keymap.set('n', '<leader>th', create_terminal_toggle('htop', 'htop'), { desc = 'Toggle htop terminal' })
      vim.keymap.set('n', '<leader>tn', create_terminal_toggle('node', 'node'), { desc = 'Toggle Node.js terminal' })
      
      -- Easy terminal mode exit
      vim.keymap.set('t', '<C-x>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
      vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
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
        { '<leader>g', group = '[G]it' },
        { '<leader>gb', group = 'Git [B]ranches' },
        { '<leader>gc', group = 'Git [C]ommit/Conflict' },
        { '<leader>gd', group = 'Git [D]iff' },
        { '<leader>gf', group = 'Git [F]ilter' },
        { '<leader>gw', group = 'Git [W]orktree' },
        { '<leader>d', group = '[D]ebug' },
      },
    },
  },

  -- Telescope
  {
    'nvim-telescope/telescope.nvim',
    branch = 'master',  -- Use stable master branch
    event = 'VimEnter',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        branch = 'main',
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
