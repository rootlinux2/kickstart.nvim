return {
  {
    'github/copilot.vim',
    event = 'InsertEnter',
    config = function()
      -- Configure Copilot
      vim.g.copilot_no_tab_map = true
      vim.g.copilot_assume_mapped = true
      vim.g.copilot_tab_fallback = ""
      
      -- Set up custom keymaps
      vim.keymap.set('i', '<C-J>', 'copilot#Accept("\\<CR>")', {
        expr = true,
        replace_keycodes = false,
        desc = 'Accept Copilot suggestion'
      })
      
      vim.keymap.set('i', '<C-H>', '<Plug>(copilot-dismiss)', {
        desc = 'Dismiss Copilot suggestion'
      })
      
      vim.keymap.set('i', '<C-L>', '<Plug>(copilot-next)', {
        desc = 'Next Copilot suggestion'
      })
      
      vim.keymap.set('i', '<C-K>', '<Plug>(copilot-previous)', {
        desc = 'Previous Copilot suggestion'
      })
      
      -- Disable Copilot for certain filetypes
      vim.g.copilot_filetypes = {
        ['*'] = true,
        ['gitcommit'] = false,
        ['markdown'] = false,
        ['yaml'] = false,
      }
      
      -- Configure Node.js memory settings for Copilot
      vim.env.NODE_OPTIONS = (vim.env.NODE_OPTIONS or '') .. ' --max-old-space-size=4096'
    end,
  },
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    branch = 'canary',
    dependencies = {
      { 'github/copilot.vim' }, -- or zbirenbaum/copilot.lua
      { 'nvim-lua/plenary.nvim' }, -- for curl, log wrapper
    },
    build = 'make tiktoken', -- Only on MacOS or Linux
    opts = {
      debug = false, -- Enable debugging
      -- See Configuration section for rest
    },
    config = function(_, opts)
      local chat = require('CopilotChat')
      local select = require('CopilotChat.select')
      
      chat.setup(opts)
      
      -- Setup keymaps
      vim.keymap.set({ 'n', 'v' }, '<leader>cc', function()
        chat.open()
      end, { desc = 'Copilot Chat - Open' })
      
      vim.keymap.set({ 'n', 'v' }, '<leader>ccq', function()
        local input = vim.fn.input('Quick Chat: ')
        if input ~= '' then
          chat.ask(input, { selection = select.buffer })
        end
      end, { desc = 'Copilot Chat - Quick chat' })
      
      vim.keymap.set({ 'n', 'v' }, '<leader>cch', function()
        local actions = require('CopilotChat.actions')
        require('CopilotChat.integrations.telescope').pick(actions.help_actions())
      end, { desc = 'Copilot Chat - Help actions' })
      
      vim.keymap.set({ 'n', 'v' }, '<leader>ccp', function()
        local actions = require('CopilotChat.actions')
        require('CopilotChat.integrations.telescope').pick(actions.prompt_actions())
      end, { desc = 'Copilot Chat - Prompt actions' })
      
      vim.keymap.set('v', '<leader>cce', function()
        chat.ask('Explain how this code works.', { selection = select.visual })
      end, { desc = 'Copilot Chat - Explain code' })
      
      vim.keymap.set('v', '<leader>ccr', function()
        chat.ask('Review this code and suggest improvements.', { selection = select.visual })
      end, { desc = 'Copilot Chat - Review code' })
      
      vim.keymap.set('v', '<leader>ccf', function()
        chat.ask('Fix this code.', { selection = select.visual })
      end, { desc = 'Copilot Chat - Fix code' })
      
      vim.keymap.set('v', '<leader>cco', function()
        chat.ask('Optimize this code.', { selection = select.visual })
      end, { desc = 'Copilot Chat - Optimize code' })
      
      vim.keymap.set('v', '<leader>ccd', function()
        chat.ask('Add documentation for this code.', { selection = select.visual })
      end, { desc = 'Copilot Chat - Document code' })
      
      vim.keymap.set('v', '<leader>cct', function()
        chat.ask('Generate tests for this code.', { selection = select.visual })
      end, { desc = 'Copilot Chat - Generate tests' })
      
      vim.keymap.set('n', '<leader>ccx', function()
        chat.close()
      end, { desc = 'Copilot Chat - Close' })
      
      vim.keymap.set('n', '<leader>ccr', function()
        chat.reset()
      end, { desc = 'Copilot Chat - Reset' })
    end,
  },
}
