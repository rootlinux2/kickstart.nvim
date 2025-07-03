return {
  'CopilotC-Nvim/CopilotChat.nvim',
  branch = 'canary',
  dependencies = {
    { 'github/copilot.vim' }, -- must be installed
    { 'nvim-lua/plenary.nvim' },
  },
  config = function()
    require('CopilotChat').setup {
      -- optional configuration
    }
  end,
  cmd = { 'CopilotChat', 'CopilotChatToggle' },
}
