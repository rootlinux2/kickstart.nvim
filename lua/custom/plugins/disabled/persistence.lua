return {
  'folke/persistence.nvim',
  event = 'BufReadPre', -- restore session on startup
  config = function()
    require('persistence').setup()
  end,
  keys = {
    {
      '<leader>qs',
      function()
        require('persistence').load()
      end,
      desc = 'Restore Session',
    },
    {
      '<leader>ql',
      function()
        require('persistence').load { last = true }
      end,
      desc = 'Restore Last Session',
    },
    {
      '<leader>qd',
      function()
        require('persistence').stop()
      end,
      desc = 'Stop Persistence',
    },
  },
}
