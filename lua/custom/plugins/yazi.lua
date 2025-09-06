return {
  "mikavilpas/yazi.nvim",
  event = "VeryLazy",
  keys = {
    -- these will be managed in keymaps.lua instead
  },
  opts = {
    -- Don't open yazi for directories to avoid conflicts with neo-tree
    open_for_directories = false,
    keymaps = {
      show_help = '<f1>',
    },
    -- Use floating window to avoid window conflicts
    floating_window_scaling_factor = 0.9,
    yazi_floating_window_winblend = 0,
  },
}
