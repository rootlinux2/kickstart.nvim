return {
  "mikavilpas/yazi.nvim",
  event = "VeryLazy",
  keys = {
    -- these will be managed in keymaps.lua instead
  },
  opts = {
    -- open yazi instead of netrw, see below for more ways to configure
    open_for_directories = true,
    keymaps = {
      show_help = '<f1>',
    },
  },
}
