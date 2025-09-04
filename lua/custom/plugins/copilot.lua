return {
  {
    'github/copilot.vim',
    event = 'InsertEnter',
    config = function()
      -- Configure Copilot
      vim.g.copilot_no_tab_map = true
      vim.g.copilot_assume_mapped = true
      vim.g.copilot_tab_fallback = ''

      -- Set up custom keymaps
      vim.keymap.set('i', '<C-J>', 'copilot#Accept("\\<CR>")', {
        expr = true,
        replace_keycodes = false,
        desc = 'Accept Copilot suggestion',
      })

      vim.keymap.set('i', '<C-H>', '<Plug>(copilot-dismiss)', {
        replace_keycodes = false,
        desc = 'Dismiss Copilot suggestion',
      })

      vim.keymap.set('i', '<C-L>', '<Plug>(copilot-next)', {
        replace_keycodes = false,
        desc = 'Next Copilot suggestion',
      })

      vim.keymap.set('i', '<C-K>', '<Plug>(copilot-previous)', {
        replace_keycodes = false,
        desc = 'Previous Copilot suggestion',
      })

      -- Disable Copilot for all filetypes except specific ones
      vim.g.copilot_filetypes = {
        ['*'] = false,
        ['lua'] = true,
        ['python'] = true,
        ['javascript'] = true,
        -- Add other filetypes you want enabled
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

      -- Keymaps
      vim.keymap.set({ 'n', 'v' }, '<leader>cc', function()
        chat.open()
      end, { desc = 'Open Copilot Chat' })

      vim.keymap.set({ 'n', 'v' }, '<leader>ccq', function()
        local input = vim.fn.input 'Quick Chat: '
        if vim.trim(input) ~= '' then
          chat.ask(input, { selection = select.buffer })
        end
      end, { desc = 'Quick chat' })

      vim.keymap.set('v', '<leader>cce', function()
        chat.ask('Explain how this code works.', { selection = select.visual })
      end, { desc = 'Explain code' })

      vim.keymap.set('v', '<leader>ccv', function()
        chat.ask('Review this code and suggest improvements.', { selection = select.visual })
      end, { desc = 'Review code' })

      vim.keymap.set('v', '<leader>ccf', function()
        chat.ask('Fix this code.', { selection = select.visual })
      end, { desc = 'Fix code' })

      vim.keymap.set('v', '<leader>cco', function()
        chat.ask('Optimize this code.', { selection = select.visual })
      end, { desc = 'Optimize code' })

      vim.keymap.set('v', '<leader>ccd', function()
        chat.ask('Add documentation for this code.', { selection = select.visual })
      end, { desc = 'Document code' })

      vim.keymap.set('v', '<leader>cct', function()
        chat.ask('Generate tests for this code.', { selection = select.visual })
      end, { desc = 'Generate tests' })

      vim.keymap.set('n', '<leader>ccx', function()
        chat.close()
      end, { desc = 'Close Copilot Chat' })

      vim.keymap.set('n', '<leader>ccr', function()
        chat.reset()
      end, { desc = 'Reset Copilot Chat' })
    end,
  },
}
