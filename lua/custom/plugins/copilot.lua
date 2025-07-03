return {
  'github/copilot.vim',
  lazy = false, -- make sure it's loaded at startup
  config = function()
    vim.g.copilot_no_tab_map = true
    vim.api.nvim_set_keymap('i', '<C-J>', 'copilot#Accept("<CR>")', { silent = true, expr = true })
  end,
}
