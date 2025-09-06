-- Transparency utilities and toggles
return {
  {
    'xiyaowong/transparent.nvim',
    lazy = false,
    priority = 999, -- Load before colorscheme
    config = function()
      require('transparent').setup {
        groups = { -- table: default groups
          'Normal', 'NormalNC', 'Comment', 'Constant', 'Special', 'Identifier',
          'Statement', 'PreProc', 'Type', 'Underlined', 'Todo', 'String', 'Function',
          'Conditional', 'Repeat', 'Operator', 'Structure', 'LineNr', 'NonText',
          'SignColumn', 'CursorLineNr', 'EndOfBuffer',
        },
        extra_groups = {
          -- Telescope
          'TelescopeNormal',
          'TelescopeBorder',
          'TelescopeTitle',
          
          -- Float and popup
          'NormalFloat',
          'FloatBorder',
          'Pmenu',
          'PmenuSbar',
          'PmenuThumb',
          
          -- LSP and diagnostics
          'DiagnosticVirtualTextError',
          'DiagnosticVirtualTextWarn',
          'DiagnosticVirtualTextInfo',
          'DiagnosticVirtualTextHint',
          
          -- Statusline and tabline
          'StatusLine',
          'StatusLineNC',
          'TabLine',
          'TabLineFill',
          'WinSeparator',
          'VertSplit',
        },
        exclude_groups = {}, -- table: groups you don't want to clear
      }
      
      -- Create user command for transparency toggle
      vim.api.nvim_create_user_command('TransparencyToggle', function()
        require('transparent').toggle()
      end, {
        desc = 'Toggle transparency for Neovim',
      })
      
      -- Add keymap for transparency toggle
      vim.keymap.set('n', '<leader>tt', function()
        require('transparent').toggle()
      end, {
        desc = '[T]oggle [T]ransparency',
        silent = true,
      })
    end,
  },
}
