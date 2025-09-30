-- Load all custom plugins
-- This file automatically loads all plugin configurations from this directory

return {
  -- Load existing plugins
  require('custom.plugins.theme'),
  require('custom.plugins.bufferline'),
  require('custom.plugins.dashboard-nvim'),
  require('custom.plugins.lsp-typescript'),
  require('custom.plugins.trouble'),
  require('custom.plugins.copilot'),
  require('custom.plugins.lazygit'),
  require('custom.plugins.mason'),
  require('custom.plugins.nvim-treesitter'),
  require('custom.plugins.which-key'),
  require('custom.plugins.todo-comment'),
  require('custom.plugins.nvim-dap'),
  require('custom.plugins.spellsitter'),
  
  -- Load new enhanced plugins
  require('custom.plugins.better-cmp'),
  require('custom.plugins.ui-enhancements'),
  require('custom.plugins.file-navigation'),
  require('custom.plugins.dev-tools'),
  require('custom.plugins.performance'),
  require('custom.plugins.enhanced-keymaps'),
}
