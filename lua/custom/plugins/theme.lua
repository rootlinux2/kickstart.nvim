return {
  'folke/tokyonight.nvim',
  lazy = false, -- or ensure it's loaded when needed
  priority = 1000,
  opts = {
    style = 'night',
  },
  config = function()
    vim.cmd [[colorscheme tokyonight]]
  end,
}
