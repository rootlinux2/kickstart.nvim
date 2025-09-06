-- Git commit message helpers and conventional commits
return {
  -- Conventional commits helper
  {
    'olexsmir/gopher.nvim',
    enabled = false, -- This is actually for Go, let's use a different one
  },

  -- Better commit message experience
  {
    'rhysd/committia.vim',
    ft = 'gitcommit',
    config = function()
      vim.g.committia_hooks = {
        edit_open = function()
          -- Set up some helpful settings for commit messages
          vim.opt_local.spell = true
          vim.opt_local.spelllang = 'en_us'
          vim.opt_local.colorcolumn = '50,72'
          vim.opt_local.textwidth = 72
          
          -- Move to the first line for commit message
          vim.cmd('startinsert')
        end
      }
    end,
  },

  -- Telescope conventional commits
  {
    'olacin/telescope-cc.nvim',
    dependencies = { 'nvim-telescope/telescope.nvim' },
    config = function()
      require('telescope').load_extension('conventional_commits')
    end,
    keys = {
      { '<leader>gcc', '<cmd>Telescope conventional_commits<CR>', desc = 'Conventional Commits' },
    },
  },

  -- Git commit message templates
  {
    'rhysd/git-messenger.vim',
    keys = {
      { '<leader>gmt', function()
        local templates = {
          'feat: add new feature',
          'fix: fix bug',
          'docs: update documentation', 
          'style: formatting changes',
          'refactor: code refactoring',
          'test: add or update tests',
          'chore: maintenance tasks',
          'perf: performance improvements',
          'ci: CI/CD changes',
          'build: build system changes',
          'revert: revert previous commit',
        }
        
        vim.ui.select(templates, {
          prompt = 'Select commit template:',
        }, function(choice)
          if choice then
            vim.fn.setreg('+', choice)
            print('Copied to clipboard: ' .. choice)
          end
        end)
      end, desc = 'Git commit templates' },
    },
  },
}
