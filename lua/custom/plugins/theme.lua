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
      highlights.LineNr = { bg = "NONE" }
      highlights.CursorLineNr = { bg = "NONE" }
      highlights.FoldColumn = { bg = "NONE" }
      
      -- Make floating windows slightly transparent but still readable
      highlights.NormalFloat = { bg = colors.bg_dark, fg = colors.fg }
      highlights.FloatBorder = { bg = "NONE", fg = colors.border }
      highlights.FloatTitle = { bg = "NONE", fg = colors.blue, bold = true }
      
      -- Make sidebars transparent
      highlights.NeoTreeNormal = { bg = "NONE" }
      highlights.NeoTreeNormalNC = { bg = "NONE" }
      highlights.NeoTreeEndOfBuffer = { bg = "NONE" }
      
      -- Make status line background transparent or semi-transparent
      highlights.StatusLine = { bg = colors.bg_dark, fg = colors.fg }
      highlights.StatusLineNC = { bg = "NONE", fg = colors.fg_dark }
      
      -- Enhanced popup menu transparency
      highlights.Pmenu = { bg = colors.bg_popup, fg = colors.fg }
      highlights.PmenuSel = { bg = colors.bg_visual, fg = colors.fg }
      highlights.PmenuSbar = { bg = colors.bg_popup }
      highlights.PmenuThumb = { bg = colors.fg_gutter }
      
      -- Enhanced telescope transparency
      highlights.TelescopeNormal = { bg = "NONE", fg = colors.fg }
      highlights.TelescopeBorder = { bg = "NONE", fg = colors.border }
      highlights.TelescopeSelection = { bg = colors.bg_visual, fg = colors.fg }
      highlights.TelescopeMatching = { fg = colors.blue }
      highlights.TelescopePromptNormal = { bg = colors.bg_dark }
      highlights.TelescopePromptBorder = { bg = colors.bg_dark, fg = colors.bg_dark }
      highlights.TelescopePromptTitle = { bg = colors.blue, fg = colors.bg }
      highlights.TelescopePreviewTitle = { bg = colors.green, fg = colors.bg }
      highlights.TelescopeResultsTitle = { bg = colors.bg_dark, fg = colors.bg_dark }
      
      -- Enhanced diagnostic colors
      highlights.DiagnosticError = { fg = colors.error }
      highlights.DiagnosticWarn = { fg = colors.warning }
      highlights.DiagnosticInfo = { fg = colors.info }
      highlights.DiagnosticHint = { fg = colors.hint }
      
      -- Enhanced cursor line
      highlights.CursorLine = { bg = colors.bg_highlight }
      
      -- Enhanced fold styling
      highlights.Folded = { bg = "NONE", fg = colors.comment }
      
      -- Enhanced visual selection
      highlights.Visual = { bg = colors.bg_visual }
      highlights.VisualNOS = { bg = colors.bg_visual }
      
      -- Enhanced search highlighting
      highlights.Search = { bg = colors.orange, fg = colors.bg }
      highlights.IncSearch = { bg = colors.orange, fg = colors.bg }
      highlights.CurSearch = { bg = colors.orange, fg = colors.bg }
      
      -- Enhanced git signs
      highlights.GitSignsAdd = { fg = colors.git.add, bg = "NONE" }
      highlights.GitSignsChange = { fg = colors.git.change, bg = "NONE" }
      highlights.GitSignsDelete = { fg = colors.git.delete, bg = "NONE" }
      
      -- Enhanced indent guides
      highlights.IblIndent = { fg = colors.fg_gutter, nocombine = true }
      highlights.IblScope = { fg = colors.purple, nocombine = true }
      
      -- Enhanced which-key
      highlights.WhichKey = { fg = colors.cyan }
      highlights.WhichKeyGroup = { fg = colors.blue }
      highlights.WhichKeyDesc = { fg = colors.fg }
      highlights.WhichKeySeperator = { fg = colors.comment }
      highlights.WhichKeyFloat = { bg = colors.bg_dark }
      highlights.WhichKeyBorder = { bg = colors.bg_dark, fg = colors.bg_dark }
    end,
  },
  config = function(_, opts)
    require("tokyonight").setup(opts)
    vim.cmd [[colorscheme tokyonight]]
  end,
}
