-- Smart and powerful comment plugin
return {
  'numToStr/Comment.nvim',
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    'JoosepAlviste/nvim-ts-context-commentstring',
  },
  config = function()
    local comment = require('Comment')
    local ts_context_commentstring = require('ts_context_commentstring.integrations.comment_nvim')
    
    comment.setup({
      -- Add a space b/w comment and the line
      padding = true,
      -- Whether the cursor should stay at its position
      sticky = true,
      -- Lines to be ignored while (un)comment
      ignore = nil,
      -- LHS of toggle mappings in NORMAL mode
      toggler = {
        line = 'gcc',        -- Line-comment toggle keymap
        block = 'gBB',       -- Block-comment toggle keymap (changed from 'gbc' to 'gBB')
      },
      -- LHS of operator-pending mappings in NORMAL and VISUAL mode
      opleader = {
        line = 'gc',         -- Line-comment keymap
        block = 'gB',        -- Block-comment keymap (changed from 'gb' to 'gB')
      },
      -- LHS of extra mappings
      extra = {
        above = 'gcO',       -- Add comment on the line above
        below = 'gco',       -- Add comment on the line below
        eol = 'gcA',         -- Add comment at the end of line
      },
      -- Enable keybindings
      mappings = {
        basic = true,        -- Operator-pending mapping; `gcc` `gBB` `gc[count]{motion}` `gB[count]{motion}`
        extra = true,        -- Extra mapping; `gco`, `gcO`, `gcA`
      },
      -- Function to call before (un)comment
      pre_hook = ts_context_commentstring.create_pre_hook(),
      -- Function to call after (un)comment
      post_hook = nil,
    })
    
    -- Additional keymaps for easier access
    local keymap = vim.keymap.set
    
    -- Toggle comment in normal and visual mode
    keymap('n', '<leader>/', function()
      require('Comment.api').toggle.linewise.current()
    end, { desc = 'Toggle comment' })
    
    keymap('v', '<leader>/', function()
      local esc = vim.api.nvim_replace_termcodes('<ESC>', true, false, true)
      vim.api.nvim_feedkeys(esc, 'nx', false)
      require('Comment.api').toggle.linewise(vim.fn.visualmode())
    end, { desc = 'Toggle comment' })
    
    -- Block comment keymaps
    keymap('n', '<leader>bc', function()
      require('Comment.api').toggle.blockwise.current()
    end, { desc = 'Toggle block comment' })
    
    keymap('v', '<leader>bc', function()
      local esc = vim.api.nvim_replace_termcodes('<ESC>', true, false, true)
      vim.api.nvim_feedkeys(esc, 'nx', false)
      require('Comment.api').toggle.blockwise(vim.fn.visualmode())
    end, { desc = 'Toggle block comment' })
  end,
}