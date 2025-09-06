-- Advanced Git Configuration and Tools
return {
  -- Git commit emoji picker
  {
    'olacin/telescope-gitmoji.nvim',
    dependencies = { 
      'nvim-telescope/telescope.nvim',
      'nvim-lua/plenary.nvim'
    },
    keys = {
      { '<leader>gce', '<cmd>Telescope gitmoji<CR>', desc = 'Git commit with emoji' },
    },
    config = function()
      require('telescope').load_extension('gitmoji')
    end,
  },

  -- Git blame viewer with virtual text
  {
    'f-person/git-blame.nvim',
    event = 'BufReadPre',
    opts = {
      enabled = false, -- disable by default, enable on demand
      message_template = ' <summary> • <date> • <author>',
      date_format = '%m-%d-%Y %H:%M:%S',
      virtual_text_column = 1,
    },
    keys = {
      { '<leader>gbt', '<cmd>GitBlameToggle<CR>', desc = 'Toggle Git Blame' },
      { '<leader>gbo', '<cmd>GitBlameOpenCommitURL<CR>', desc = 'Open Commit URL' },
      { '<leader>gbc', '<cmd>GitBlameCopyCommitURL<CR>', desc = 'Copy Commit URL' },
    },
  },

  -- Enhanced git integration with floating windows
  {
    'NeogitOrg/neogit',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'sindrets/diffview.nvim',
      'nvim-telescope/telescope.nvim',
    },
    config = true,
    keys = {
      { '<leader>gn', '<cmd>Neogit<CR>', desc = 'Open Neogit' },
      { '<leader>gnc', '<cmd>Neogit commit<CR>', desc = 'Neogit commit' },
      { '<leader>gnp', '<cmd>Neogit push<CR>', desc = 'Neogit push' },
      { '<leader>gnl', '<cmd>Neogit pull<CR>', desc = 'Neogit pull' },
    },
  },

  -- Git time machine
  {
    'fredeeb/tardis.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = true,
    keys = {
      { '<leader>gt', '<cmd>Tardis<CR>', desc = 'Git time machine' },
    },
  },

  -- GitHub CLI integration
  {
    'pwntester/octo.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      require('octo').setup({
        enable_builtin = true,
        default_remote = {'upstream', 'origin'},
        ssh_aliases = {},
        reaction_viewer_hint_icon = '',
        user_icon = ' ',
        timeline_marker = '',
        timeline_indent = '2',
        right_bubble_delimiter = '',
        left_bubble_delimiter = '',
        github_hostname = '',
        snippet_context_lines = 4,
        gh_env = {},
        ui = {
          use_signcolumn = true,
        },
        issues = {
          order_by = {
            field = 'CREATED_AT',
            direction = 'DESC'
          }
        },
        pull_requests = {
          order_by = {
            field = 'CREATED_AT',
            direction = 'DESC'
          },
          always_select_remote_on_create = false
        }
      })
    end,
    cmd = 'Octo',
    keys = {
      { '<leader>gho', '<cmd>Octo<CR>', desc = 'Open Octo' },
      { '<leader>ghi', '<cmd>Octo issue list<CR>', desc = 'List GitHub issues' },
      { '<leader>ghp', '<cmd>Octo pr list<CR>', desc = 'List GitHub PRs' },
      { '<leader>ghr', '<cmd>Octo repo view<CR>', desc = 'View GitHub repo' },
      { '<leader>ghc', '<cmd>Octo pr create<CR>', desc = 'Create GitHub PR' },
    },
  },

  -- Git graph visualization
  {
    'isakbm/gitgraph.nvim',
    dependencies = { 'sindrets/diffview.nvim' },
    opts = {
      symbols = {
        merge_commit = '',
        commit = '',
        merge_commit_end = '',
        commit_end = '',
        -- Advanced symbols
        GVER = '',
        GHOR = '─',
        GCLD = '╮',
        GCRD = '╭',
        GCLU = '╯',
        GCRU = '╰',
        GLRU = '┴',
        GLRD = '┬',
        GLUD = '┤',
        GRUD = '├',
        GFORKU = '┼',
        GFORKD = '┼',
        GRUDCD = '├',
        GRUDCU = '├',
        GLUDCD = '┤',
        GLUDCU = '┤',
        GLRDCL = '┬',
        GLRDCR = '┬',
        GLRUCL = '┴',
        GLRUCR = '┴',
      },
      format = {
        timestamp = '%H:%M:%S %d-%m-%Y',
        fields = { 'hash', 'timestamp', 'author', 'branch_name', 'tag' },
      },
      hooks = {
        on_select_commit = function(commit)
          print('Selected commit:', commit.hash)
        end,
        on_select_range_commit = function(from, to)
          print('Selected range:', from.hash, 'to', to.hash)
        end,
      },
    },
    keys = {
      { '<leader>ggl', function() require('gitgraph').draw({}, { all = true, max_count = 5000 }) end, desc = 'GitGraph - Draw' },
    },
  },

  -- Advanced git hunk operations
  {
    'tanvirtin/vgit.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('vgit').setup({
        keymaps = {
          ['n <C-k>'] = function() require('vgit').hunk_up() end,
          ['n <C-j>'] = function() require('vgit').hunk_down() end,
          ['n <leader>gs'] = function() require('vgit').buffer_hunk_stage() end,
          ['n <leader>gr'] = function() require('vgit').buffer_hunk_reset() end,
          ['n <leader>gp'] = function() require('vgit').buffer_hunk_preview() end,
          ['n <leader>gb'] = function() require('vgit').buffer_blame_preview() end,
          ['n <leader>gf'] = function() require('vgit').buffer_diff_preview() end,
          ['n <leader>gh'] = function() require('vgit').buffer_history_preview() end,
          ['n <leader>gu'] = function() require('vgit').buffer_reset() end,
          ['n <leader>gg'] = function() require('vgit').buffer_gutter_blame_preview() end,
          ['n <leader>glu'] = function() require('vgit').project_hunks_preview() end,
          ['n <leader>gls'] = function() require('vgit').project_hunks_staged_preview() end,
          ['n <leader>gd'] = function() require('vgit').project_diff_preview() end,
          ['n <leader>gq'] = function() require('vgit').project_hunks_qf() end,
          ['n <leader>gx'] = function() require('vgit').toggle_live_blame() end,
          ['n <leader>gts'] = function() require('vgit').toggle_tracing() end,
          ['n <leader>gtd'] = function() require('vgit').toggle_diff_preference() end,
        },
        settings = {
          hls = {
            GitSignsAdd = { fg = '#8ec07c' },
            GitSignsChange = { fg = '#d79921' },
            GitSignsDelete = { fg = '#fb4934' },
          },
          live_blame = {
            enabled = true,
          },
          live_gutter = {
            enabled = true,
          },
          scene = {
            diff_preference = 'unified',
          },
        }
      })
    end,
    enabled = false, -- disable by default to avoid conflicts with gitsigns
  },
}
