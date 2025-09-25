return {
  {
    'github/copilot.vim',
    event = 'InsertEnter',
    config = function()
      -- Configure Copilot
      vim.g.copilot_no_tab_map = true
      vim.g.copilot_assume_mapped = true
      vim.g.copilot_tab_fallback = ''
      
      -- Enable logging for debugging (remove after fixing)
      vim.g.copilot_debug = true

      -- Enable Copilot for specific filetypes (or enable for all by default)
      vim.g.copilot_filetypes = {
        ['*'] = true,  -- Enable for all filetypes by default
        ['gitcommit'] = false, -- Disable for git commits
        ['gitrebase'] = false, -- Disable for git rebase
        ['hgcommit'] = false,  -- Disable for mercurial commits
        ['svn'] = false,       -- Disable for SVN
        ['cvs'] = false,       -- Disable for CVS
        ['lua'] = true,
        ['python'] = true,
        ['javascript'] = true,
        ['typescript'] = true,
        ['javascriptreact'] = true,
        ['typescriptreact'] = true,
        ['json'] = true,
        ['html'] = true,
        ['css'] = true,
        ['scss'] = true,
        ['markdown'] = true,
        ['yaml'] = true,
        ['toml'] = true,
        ['bash'] = true,
        ['sh'] = true,
        ['zsh'] = true,
      }

      -- Configure Node.js memory settings for Copilot
      vim.env.NODE_OPTIONS = (vim.env.NODE_OPTIONS and vim.env.NODE_OPTIONS .. ' ' or '') .. '--max-old-space-size=4096'
    end,
  },
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    branch = 'main',
    dependencies = {
      'github/copilot.vim',
      'nvim-lua/plenary.nvim',
    },
    build = 'make tiktoken', -- Only needed for advanced features (local token counting) on Linux/macOS
    opts = {
      debug = false,
      -- Add more options here if needed
    },
    config = function(_, opts)
      local chat = require 'CopilotChat'
      local select = require 'CopilotChat.select'

      chat.setup(opts)
    end,
  },
}
