return {
  'lewis6991/spellsitter.nvim',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  config = function()
    require('spellsitter').setup()
  end,
  event = { 'BufReadPost', 'BufNewFile' },
}
