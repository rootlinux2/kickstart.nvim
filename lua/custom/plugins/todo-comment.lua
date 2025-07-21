return {
  'folke/todo-comments.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'folke/trouble.nvim',
  },
  opts = {},
  config = function()
    require('todo-comments').setup()
  end,
  keys = {
    { '<leader>xt', '<cmd>TodoTrouble<CR>', desc = 'Todo (Trouble)' },
    { '<leader>xT', '<cmd>TodoTrouble keywords=TODO,FIX,FIXME<CR>', desc = 'Todo/Fix/Fixme (Trouble)' },
    { '<leader>st', '<cmd>TodoTelescope<CR>', desc = 'Todo' },
  },
}
