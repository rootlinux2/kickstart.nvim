-- Additional Git Tools and Utilities
return {
  -- Git worktree management
  {
    'ThePrimeagen/git-worktree.nvim',
    dependencies = { 'nvim-telescope/telescope.nvim' },
    config = function()
      require('git-worktree').setup()
      require('telescope').load_extension('git_worktree')
    end,
    keys = {
      { '<leader>gww', function() require('telescope').extensions.git_worktree.git_worktrees() end, desc = 'Git Worktrees' },
      { '<leader>gwc', function() require('telescope').extensions.git_worktree.create_git_worktree() end, desc = 'Create Git Worktree' },
    },
  },

  -- Git integration for telescope
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      'nvim-telescope/telescope-fzf-native.nvim',
      'nvim-telescope/telescope-ui-select.nvim',
    },
    keys = {
      -- Git telescope commands
      { '<leader>gbb', '<cmd>Telescope git_branches<CR>', desc = 'Git Branches' },
      { '<leader>gbc', '<cmd>Telescope git_commits<CR>', desc = 'Git Commits' },
      { '<leader>gbf', '<cmd>Telescope git_bcommits<CR>', desc = 'Git Buffer Commits' },
      { '<leader>gst', '<cmd>Telescope git_status<CR>', desc = 'Git Status' },
      { '<leader>gsh', '<cmd>Telescope git_stash<CR>', desc = 'Git Stash' },
      { '<leader>sgc', '<cmd>Telescope git_commits<CR>', desc = '[S]earch [G]it [C]ommits' },
      { '<leader>sgb', '<cmd>Telescope git_branches<CR>', desc = '[S]earch [G]it [B]ranches' },
    },
  },

  -- Enhanced fugitive with better integration
  {
    'tpope/vim-fugitive',
    cmd = { 'Git', 'Gdiff', 'Gdiffsplit', 'Gvdiffsplit', 'Gwrite', 'Gread' },
    keys = {
      { '<leader>Git', '<cmd>Git<CR>', desc = 'Git status (fugitive)' },
      { '<leader>gw', '<cmd>Gwrite<CR>', desc = 'Git write (stage file)' },
      { '<leader>gr', '<cmd>Gread<CR>', desc = 'Git read (checkout file)' },
      { '<leader>gds', '<cmd>Gdiffsplit<CR>', desc = 'Git diff split' },
      { '<leader>gdv', '<cmd>Gvdiffsplit<CR>', desc = 'Git diff vertical split' },
      { '<leader>gb', '<cmd>Git blame<CR>', desc = 'Git blame' },
      { '<leader>gB', '<cmd>GBrowse<CR>', desc = 'Git browse' },
    },
  },

  -- GitHub integration
  {
    'tpope/vim-rhubarb',
    dependencies = { 'tpope/vim-fugitive' },
    cmd = { 'GBrowse' },
  },

  -- Git commit browser
  {
    'junegunn/gv.vim',
    dependencies = { 'tpope/vim-fugitive' },
    cmd = { 'GV' },
    keys = {
      { '<leader>gv', '<cmd>GV<CR>', desc = 'Git commit browser' },
      { '<leader>gV', '<cmd>GV!<CR>', desc = 'Git commit browser (current file)' },
    },
  },

  -- Git messenger (show commit info)
  {
    'rhysd/git-messenger.vim',
    cmd = 'GitMessenger',
    keys = {
      { '<leader>gm', '<cmd>GitMessenger<CR>', desc = 'Git messenger' },
    },
    init = function()
      vim.g.git_messenger_no_default_mappings = true
      vim.g.git_messenger_always_into_popup = true
      vim.g.git_messenger_popup_content_margins = false
      vim.g.git_messenger_float_win_opts = { border = 'rounded' }
      vim.g.git_messenger_preview_mods = 'botright'
    end,
  },

  -- Git signs line highlighting
  {
    'airblade/vim-gitgutter',
    enabled = false, -- Disable since we're using gitsigns
  },

  -- Advanced git log viewer
  {
    'rbong/vim-flog',
    dependencies = { 'tpope/vim-fugitive' },
    cmd = { 'Flog', 'Flogsplit', 'Floggit' },
    keys = {
      { '<leader>gfl', '<cmd>Flog<CR>', desc = 'Git log (flog)' },
      { '<leader>gfs', '<cmd>Flogsplit<CR>', desc = 'Git log split (flog)' },
    },
  },

  -- Gitignore generator
  {
    'wintermute-cell/gitignore.nvim',
    dependencies = { 'nvim-telescope/telescope.nvim' },
    cmd = 'Gitignore',
    keys = {
      { '<leader>gi', '<cmd>Gitignore<CR>', desc = 'Generate .gitignore' },
    },
  },
}
