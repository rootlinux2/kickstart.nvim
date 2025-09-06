return {
  {
    'projekt0n/github-nvim-theme',
    name = 'github-theme',
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      require('github-theme').setup {
        options = {
          -- Compile the colorscheme when a change is made
          compile_path = vim.fn.stdpath('cache') .. '/github-theme',
          compile_file_suffix = '_compiled',
          hide_end_of_buffer = true, -- Hide the '~' character at the end of the buffer for a cleaner look
          hide_nc_statusline = true, -- Override the underline style for non-active statuslines
          
          -- Transparency settings
          transparent = true, -- Disable setting background
          terminal_colors = true, -- Set terminal colors (e.g. `g:terminal_color_0`)
          dim_inactive = false, -- Non focused panes set to alternative background
          module_default = true, -- Default enable value for modules
          
          styles = {
            comments = 'italic',
            keywords = 'bold,italic',
            functions = 'bold',
            variables = 'NONE',
            conditionals = 'NONE',
            constants = 'bold',
            numbers = 'NONE',
            operators = 'NONE',
            strings = 'NONE',
            types = 'italic,bold',
          },
          
          inverse = { -- Inverse highlight for different types
            match_paren = false,
            visual = false,
            search = false,
          },
          
          darken = { -- Darken floating windows and sidebar-like windows
            floats = false,
            sidebars = {
              enable = true,
              list = { 'qf', 'vista_kind', 'terminal', 'packer' },
            },
          },
          
          modules = {
            diagnostic = {
              enable = true,
              background = false, -- Transparent diagnostic backgrounds
            },
          },
        },
        
        palettes = {
          -- Custom color overrides can go here
          github_dark_default = {
            -- You can override specific colors if needed
            -- bg0 = '#0d1117', -- Main background
            -- bg1 = '#161b22', -- Sidebar background
          },
        },
        
        specs = {
          -- Custom highlight specifications
          github_dark_default = {
            -- Custom syntax highlighting overrides
          },
        },
        
        groups = {
          -- Custom highlight group overrides
          github_dark_default = {
            -- Make specific elements transparent
            Normal = { bg = 'NONE' },
            NormalNC = { bg = 'NONE' },
            SignColumn = { bg = 'NONE' },
            LineNr = { bg = 'NONE' },
            CursorLineNr = { bg = 'NONE' },
            VertSplit = { bg = 'NONE' },
            WinSeparator = { bg = 'NONE' },
            EndOfBuffer = { bg = 'NONE' },
            
            -- Float and popup transparency
            NormalFloat = { bg = 'NONE' },
            FloatBorder = { bg = 'NONE' },
            Pmenu = { bg = 'NONE' },
            PmenuSbar = { bg = 'NONE' },
            PmenuThumb = { bg = 'NONE' },
            
            -- Telescope transparency
            TelescopeNormal = { bg = 'NONE' },
            TelescopeBorder = { bg = 'NONE' },
            TelescopeTitle = { bg = 'NONE' },
            TelescopeSelection = { bg = '#2d333b' },
            TelescopeSelectionCaret = { bg = '#2d333b' },
            
            -- Tree-sitter and syntax transparency
            ['@text.literal'] = { bg = 'NONE' },
            ['@text.uri'] = { bg = 'NONE' },
            
            -- Git signs with better contrast
            GitSignsAdd = { fg = '#238636', bg = 'NONE' },
            GitSignsChange = { fg = '#d29922', bg = 'NONE' },
            GitSignsDelete = { fg = '#da3633', bg = 'NONE' },
            
            -- Diagnostic highlights with transparency
            DiagnosticVirtualTextError = { bg = 'NONE' },
            DiagnosticVirtualTextWarn = { bg = 'NONE' },
            DiagnosticVirtualTextInfo = { bg = 'NONE' },
            DiagnosticVirtualTextHint = { bg = 'NONE' },
            
            -- LSP and completion menu
            CmpItemMenu = { bg = 'NONE' },
            CmpItemAbbr = { bg = 'NONE' },
            CmpItemAbbrMatch = { bg = 'NONE' },
            CmpItemAbbrMatchFuzzy = { bg = 'NONE' },
            
            -- Statusline transparency
            StatusLine = { bg = 'NONE' },
            StatusLineNC = { bg = 'NONE' },
            
            -- Tabline transparency
            TabLine = { bg = 'NONE' },
            TabLineFill = { bg = 'NONE' },
            TabLineSel = { bg = '#2d333b' },
            
            -- Which-key transparency
            WhichKey = { bg = 'NONE' },
            WhichKeyGroup = { bg = 'NONE' },
            WhichKeyDesc = { bg = 'NONE' },
            WhichKeySeperator = { bg = 'NONE' },
            WhichKeyFloat = { bg = 'NONE' },
            WhichKeyBorder = { bg = 'NONE' },
          },
        },
      }

      vim.cmd([[colorscheme github_dark_default]])
      
      -- Additional transparency settings that might be needed
      vim.api.nvim_create_autocmd('ColorScheme', {
        pattern = '*',
        callback = function()
          -- Ensure these remain transparent even after colorscheme changes
          local transparent_groups = {
            'Normal', 'NormalNC', 'SignColumn', 'LineNr', 'CursorLineNr',
            'VertSplit', 'WinSeparator', 'EndOfBuffer', 'NormalFloat',
            'FloatBorder', 'Pmenu', 'PmenuSbar', 'PmenuThumb',
            'TelescopeNormal', 'TelescopeBorder', 'TelescopeTitle'
          }
          
          for _, group in ipairs(transparent_groups) do
            vim.cmd(string.format('highlight %s guibg=NONE ctermbg=NONE', group))
          end
        end,
      })
    end,
  },

  -- Alternative theme option with built-in transparency support
  {
    'folke/tokyonight.nvim',
    enabled = false, -- Set to true if you want to try this theme instead
    lazy = false,
    priority = 1000,
    opts = {
      style = 'storm', -- storm, moon, night, day
      transparent = true,
      terminal_colors = true,
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
        functions = { bold = true },
        variables = {},
        sidebars = 'transparent',
        floats = 'transparent',
      },
      sidebars = { 'qf', 'help', 'vista_kind', 'terminal', 'packer' },
      day_brightness = 0.3,
      hide_inactive_statusline = false,
      dim_inactive = false,
      lualine_bold = false,
    },
  },

  -- Another excellent transparent theme option
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    enabled = false, -- Set to true if you want to try this theme instead
    lazy = false,
    priority = 1000,
    opts = {
      flavour = 'mocha', -- latte, frappe, macchiato, mocha
      background = {
        light = 'latte',
        dark = 'mocha',
      },
      transparent_background = true,
      show_end_of_buffer = false,
      term_colors = true,
      dim_inactive = {
        enabled = false,
        shade = 'dark',
        percentage = 0.15,
      },
      no_italic = false,
      no_bold = false,
      no_underline = false,
      styles = {
        comments = { 'italic' },
        conditionals = { 'italic' },
        loops = {},
        functions = { 'bold' },
        keywords = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = { 'italic' },
        operators = {},
      },
      integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        telescope = true,
        treesitter = true,
        which_key = true,
      },
    },
  },
}
