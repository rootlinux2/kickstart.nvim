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
  keys = {
    { '\\', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
  },
  opts = {
    close_if_last_window = false, -- Close Neo-tree if it is the last window left in the tab
    popup_border_style = 'rounded',
    enable_git_status = true,
    enable_diagnostics = true,
    filesystem = {
      hijack_netrw_behavior = "disabled",
      window = {
        mappings = {
          ['\\'] = 'close_window',
          ['t'] = 'open_tabnew',
        },
      },
      filtered_items = {
        visible = true, -- 👈 Show hidden files in the tree
        hide_dotfiles = false, -- 👈 Do not hide dotfiles
        hide_gitignored = false,
      },
    },
  },
}
