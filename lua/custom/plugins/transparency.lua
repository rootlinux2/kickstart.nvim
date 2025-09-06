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
          'TelescopePromptNormal',
          'TelescopePromptBorder',
          'TelescopePromptTitle',
          'TelescopePreviewNormal',
          'TelescopePreviewBorder',
          'TelescopePreviewTitle',
          'TelescopeResultsNormal',
          'TelescopeResultsBorder',
          'TelescopeResultsTitle',
          
          -- Float and popup
          'NormalFloat',
          'FloatBorder',
          'Pmenu',
          'PmenuSbar',
          'PmenuThumb',
          
          -- Tree and explorer
          'NeoTreeNormal',
          'NeoTreeNormalNC',
          'NeoTreeWinSeparator',
          
          -- Git
          'GitSignsAdd',
          'GitSignsChange',
          'GitSignsDelete',
          
          -- Which-key
          'WhichKey',
          'WhichKeyGroup',
          'WhichKeyDesc',
          'WhichKeySeperator',
          'WhichKeyFloat',
          'WhichKeyBorder',
          
          -- LSP and diagnostics
          'DiagnosticVirtualTextError',
          'DiagnosticVirtualTextWarn',
          'DiagnosticVirtualTextInfo',
          'DiagnosticVirtualTextHint',
          
          -- Completion
          'CmpItemMenu',
          'CmpItemAbbr',
          'CmpItemAbbrMatch',
          'CmpItemAbbrMatchFuzzy',
          
          -- Statusline and tabline
          'StatusLine',
          'StatusLineNC',
          'TabLine',
          'TabLineFill',
          'WinSeparator',
          'VertSplit',
          
          -- Buffer line
          'BufferLineBackground',
          'BufferLineFill',
          'BufferLineTab',
          'BufferLineTabSelected',
          'BufferLineTabClose',
          'BufferLineCloseButton',
          'BufferLineCloseButtonSelected',
          'BufferLineCloseButtonVisible',
          'BufferLineSeparator',
          'BufferLineSeparatorSelected',
          'BufferLineSeparatorVisible',
          'BufferLineIndicatorSelected',
          'BufferLineModified',
          'BufferLineModifiedSelected',
          'BufferLineModifiedVisible',
          'BufferLineDuplicate',
          'BufferLineDuplicateSelected',
          'BufferLineDuplicateVisible',
          'BufferLinePickSelected',
          'BufferLinePickVisible',
          'BufferLinePick',
          'BufferLineNumbers',
          'BufferLineNumbersSelected',
          'BufferLineNumbersVisible',
          
          -- Dashboard
          'DashboardShortCut',
          'DashboardHeader',
          'DashboardCenter',
          'DashboardFooter',
          
          -- Trouble
          'TroubleNormal',
          'TroubleNormalNC',
          
          -- Mason
          'MasonNormal',
          'MasonNormalNC',
          
          -- Lazy
          'LazyNormal',
          'LazyNormalNC',
        },
        exclude_groups = {}, -- table: groups you don't want to clear
      }
      
      -- Custom transparency toggle functions
      local transparency_enabled = true
      
      local function toggle_transparency()
        if transparency_enabled then
          require('transparent').clear_prefix('BufferLine')
          require('transparent').clear_prefix('NeoTree')
          require('transparent').clear_prefix('Telescope')
          require('transparent').clear_prefix('WhichKey')
          require('transparent').clear_prefix('Cmp')
          require('transparent').clear_prefix('Dashboard')
          require('transparent').clear_prefix('Trouble')
          require('transparent').clear_prefix('Mason')
          require('transparent').clear_prefix('Lazy')
          transparency_enabled = false
          print('Transparency disabled')
        else
          require('transparent').toggle()
          transparency_enabled = true
          print('Transparency enabled')
        end
      end
      
      -- Create user command for transparency toggle
      vim.api.nvim_create_user_command('TransparencyToggle', toggle_transparency, {
        desc = 'Toggle transparency for Neovim',
      })
      
      -- Add keymap for transparency toggle
      vim.keymap.set('n', '<leader>tt', toggle_transparency, {
        desc = '[T]oggle [T]ransparency',
        silent = true,
      })
      
      -- Auto-apply transparency on colorscheme change
      vim.api.nvim_create_autocmd('ColorScheme', {
        pattern = '*',
        callback = function()
          if transparency_enabled then
            vim.defer_fn(function()
              require('transparent').toggle()
              require('transparent').toggle() -- Double toggle to refresh
            end, 100)
          end
        end,
      })
    end,
  },
}
