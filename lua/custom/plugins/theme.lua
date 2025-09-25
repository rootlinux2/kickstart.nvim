return {
  'folke/tokyonight.nvim',
  lazy = false, -- or ensure it's loaded when needed
  priority = 1000,
  opts = {
    style = 'night',
    transparent = true, -- Enable transparency
    terminal_colors = true, -- Configure the colors used when opening a `:terminal`
    styles = {
      -- Style to be applied to different syntax groups
      comments = { italic = true },
      keywords = { italic = true },
      functions = {},
      variables = {},
      -- Background styles. Can be "dark", "transparent" or "normal"
      sidebars = "transparent", -- style for sidebars, see below
      floats = "transparent", -- style for floating windows
    },
    sidebars = { "qf", "help", "NvimTree", "neo-tree" }, -- Set a darker background on sidebar-like windows
    day_brightness = 0.3, -- Adjusts the brightness of the colors of the **Day** style
    hide_inactive_statusline = false, -- Enabling this option, will hide inactive statuslines and replace them with a thin border instead
    dim_inactive = false, -- dims inactive windows
    lualine_bold = false, -- When `true`, section headers in the lualine theme will be bold
    
    --- You can override specific color groups to use other groups or a hex color
    --- function will be called with a ColorScheme table
    on_colors = function(colors)
      -- You can modify colors here if needed
    end,
    
    --- You can override specific highlights to use other groups or a hex color
    --- function will be called with a Highlights and ColorScheme table
    on_highlights = function(highlights, colors)
      -- Make the background completely transparent
      highlights.Normal = { bg = "NONE" }
      highlights.NormalNC = { bg = "NONE" }
      highlights.SignColumn = { bg = "NONE" }
      highlights.EndOfBuffer = { bg = "NONE" }
      
      -- Make floating windows slightly transparent but still readable
      highlights.NormalFloat = { bg = colors.bg_dark, fg = colors.fg }
      highlights.FloatBorder = { bg = "NONE", fg = colors.border }
      
      -- Make sidebars transparent
      highlights.NeoTreeNormal = { bg = "NONE" }
      highlights.NeoTreeNormalNC = { bg = "NONE" }
      
      -- Make status line background transparent or semi-transparent
      highlights.StatusLine = { bg = colors.bg_dark, fg = colors.fg }
      highlights.StatusLineNC = { bg = "NONE", fg = colors.fg_dark }
    end,
  },
  config = function(_, opts)
    require("tokyonight").setup(opts)
    vim.cmd [[colorscheme tokyonight]]
  end,
}
