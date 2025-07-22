return {
  'kdheepak/lazygit.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  config = function()
    vim.keymap.set('n', '<leader>gg', ':LazyGit<CR>', { desc = 'Open LazyGit' })
    vim.keymap.set('n', '<leader>gc', ':LazyGitCurrentFile<CR>', { desc = 'LazyGit current file' })
    vim.keymap.set('n', '<leader>gf', ':LazyGitFilter<CR>', { desc = 'LazyGit filter commits' })
  end,
}
