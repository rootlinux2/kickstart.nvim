return {
  -- Enhanced LazyGit integration
  {
    'kdheepak/lazygit.nvim',
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    keys = {
      { '<leader>ggg', function()
          vim.cmd('tabnew')
          vim.cmd('enew')
          vim.cmd('LazyGit')
        end, desc = 'Open LazyGit (new tab)' },
      { '<leader>lg', function()
          vim.cmd('enew')
          vim.cmd('LazyGit')
        end, desc = 'Open LazyGit' },
      { '<leader>gc', function()
          vim.cmd('enew')
          vim.cmd('LazyGitCurrentFile')
        end, desc = 'LazyGit current file' },
      { '<leader>gf', function()
          vim.cmd('enew')
          vim.cmd('LazyGitFilter')
        end, desc = 'LazyGit filter commits' },
      { '<leader>gF', function()
          vim.cmd('enew')
          vim.cmd('LazyGitFilterCurrentFile')
        end, desc = 'LazyGit filter current file' },
    },
    config = function()
      -- LazyGit configuration
      vim.g.lazygit_floating_window_winblend = 0 -- transparency of floating window
      vim.g.lazygit_floating_window_scaling_factor = 0.9 -- scaling factor for floating window
      vim.g.lazygit_floating_window_border_chars = {'╭','─', '╮', '│', '╯','─', '╰', '│'} -- customize lazygit popup window border characters
      vim.g.lazygit_floating_window_use_plenary = 0 -- use plenary.nvim to manage floating window if available
      vim.g.lazygit_use_neovim_remote = 1 -- fallback to 0 if neovim-remote is not installed
      vim.g.lazygit_use_custom_config_file_path = 0 -- config file path is evaluated if this value is 1
      vim.g.lazygit_config_file_path = '' -- custom config file path
    end,
  },

  -- Git diff viewer
  {
    'sindrets/diffview.nvim',
    cmd = { 'DiffviewOpen', 'DiffviewClose', 'DiffviewToggleFiles', 'DiffviewFocusFiles' },
    keys = {
      { '<leader>gd', '<cmd>DiffviewOpen<CR>', desc = 'Open Diffview' },
      { '<leader>gD', '<cmd>DiffviewClose<CR>', desc = 'Close Diffview' },
      { '<leader>gh', '<cmd>DiffviewFileHistory<CR>', desc = 'File History' },
      { '<leader>gH', '<cmd>DiffviewFileHistory %<CR>', desc = 'Current File History' },
    },
    opts = {
      enhanced_diff_hl = true,
      view = {
        default = { layout = "diff2_horizontal" },
        merge_tool = { layout = "diff3_horizontal" },
      },
    },
  },

  -- Git conflict resolution
  {
    'akinsho/git-conflict.nvim',
    event = 'BufReadPre',
    opts = {
      default_mappings = {
        ours = 'co',
        theirs = 'ct',
        none = 'c0',
        both = 'cb',
        next = ']x',
        prev = '[x',
      },
      default_commands = true,
      disable_diagnostics = false,
      list_opener = 'copen',
      highlights = {
        incoming = 'DiffAdd',
        current = 'DiffText',
      }
    },
    keys = {
      { '<leader>gco', '<cmd>GitConflictChooseOurs<CR>', desc = 'Choose Ours (Git Conflict)' },
      { '<leader>gct', '<cmd>GitConflictChooseTheirs<CR>', desc = 'Choose Theirs (Git Conflict)' },
      { '<leader>gcb', '<cmd>GitConflictChooseBoth<CR>', desc = 'Choose Both (Git Conflict)' },
      { '<leader>gc0', '<cmd>GitConflictChooseNone<CR>', desc = 'Choose None (Git Conflict)' },
      { '<leader>gcn', '<cmd>GitConflictNextConflict<CR>', desc = 'Next Conflict' },
      { '<leader>gcp', '<cmd>GitConflictPrevConflict<CR>', desc = 'Previous Conflict' },
      { '<leader>gcl', '<cmd>GitConflictListQf<CR>', desc = 'List Conflicts' },
    },
  },

  -- Advanced git signs
  {
    'lewis6991/gitsigns.nvim',
    event = 'BufReadPre',
    opts = {
      signs = {
        add = { text = '│' },
        change = { text = '│' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
        untracked = { text = '┆' },
      },
      signs_staged = {
        add = { text = '│' },
        change = { text = '│' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      current_line_blame = false,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'eol',
        delay = 1000,
        ignore_whitespace = false,
      },
      current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
      preview_config = {
        border = 'rounded',
        style = 'minimal',
        relative = 'cursor',
        row = 0,
        col = 1
      },
      on_attach = function(bufnr)
        local gitsigns = require('gitsigns')

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']h', function()
          if vim.wo.diff then
            vim.cmd.normal { ']c', bang = true }
          else
            gitsigns.nav_hunk('next')
          end
        end, { desc = 'Next git hunk' })

        map('n', '[h', function()
          if vim.wo.diff then
            vim.cmd.normal { '[c', bang = true }
          else
            gitsigns.nav_hunk('prev')
          end
        end, { desc = 'Previous git hunk' })

        -- Actions
        map('n', '<leader>hs', gitsigns.stage_hunk, { desc = 'Stage hunk' })
        map('n', '<leader>hr', gitsigns.reset_hunk, { desc = 'Reset hunk' })
        map('v', '<leader>hs', function() gitsigns.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end, { desc = 'Stage hunk' })
        map('v', '<leader>hr', function() gitsigns.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end, { desc = 'Reset hunk' })
        map('n', '<leader>hS', gitsigns.stage_buffer, { desc = 'Stage buffer' })
        map('n', '<leader>hu', gitsigns.undo_stage_hunk, { desc = 'Undo stage hunk' })
        map('n', '<leader>hR', gitsigns.reset_buffer, { desc = 'Reset buffer' })
        map('n', '<leader>hp', gitsigns.preview_hunk, { desc = 'Preview hunk' })
        map('n', '<leader>hb', function() gitsigns.blame_line{full=true} end, { desc = 'Blame line' })
        map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = 'Toggle line blame' })
        map('n', '<leader>hd', gitsigns.diffthis, { desc = 'Diff this' })
        map('n', '<leader>hD', function() gitsigns.diffthis('~') end, { desc = 'Diff this ~' })
        map('n', '<leader>td', gitsigns.toggle_deleted, { desc = 'Toggle deleted' })

        -- Text object
        map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = 'Select git hunk' })
      end
    },
  },
}
