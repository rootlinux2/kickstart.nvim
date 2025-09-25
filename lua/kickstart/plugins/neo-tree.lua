-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  lazy = true,
  opts = {
    close_if_last_window = false, -- Don't close Neo-tree if it's the last window
    popup_border_style = 'rounded',
    enable_git_status = true,
    enable_diagnostics = true,
  },
}
