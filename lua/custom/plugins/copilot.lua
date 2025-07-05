return {
  'github/copilot.vim', -- GitHub Copilot plugin
  event = 'InsertEnter', -- Load Copilot when entering insert mode
  config = function()
    -- Optional: Configure Copilot behavior
    vim.g.copilot_no_tab_map = true -- Disable default <Tab> mapping
    vim.api.nvim_set_keymap('i', '<C-c>', 'copilot#Accept("<CR>")', { silent = true, expr = true, noremap = true })
  end,
}
