return {
  -- Other plugins here
  {
    'folke/tokyonight.nvim',
    lazy = false, -- Load immediately
    priority = 1000, -- Load before other colorschemes
    config = function()
      -- Optional configuration
      require("tokyonight").setup({
        style = "night",  -- "storm", "night", "day", or "moon"
        transparent = false,
        terminal_colors = true,
        styles = {
          comments = { italic = true },
          keywords = { italic = false },
          functions = { bold = true },
        },
      })
      -- Set colorscheme
      vim.cmd([[colorscheme tokyonight]])
    end,
  },
}

