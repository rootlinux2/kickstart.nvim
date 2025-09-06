return {
  'akinsho/bufferline.nvim',
  version = '*',
  dependencies = 'nvim-tree/nvim-web-devicons',
  config = function()
    require('bufferline').setup {
      options = {
        mode = 'buffers', -- set to "tabs" to only show tabpages instead
        style_preset = require('bufferline').style_preset.no_bold, -- or style_preset.minimal
        themable = true, -- allows highlight groups to be overridden i.e. sets highlights as default
        numbers = 'none', -- | "ordinal" | "buffer_id" | "both" | function({ ordinal, id, lower, raise }): string,
        close_command = 'bdelete! %d', -- can be a string | function, see "Mouse actions"
        right_mouse_command = 'bdelete! %d', -- can be a string | function, see "Mouse actions"
        left_mouse_command = 'buffer %d', -- can be a string | function, see "Mouse actions"
        middle_mouse_command = nil, -- can be a string | function, see "Mouse actions"
        indicator = {
          icon = '▎', -- this should be omitted if indicator style is not 'icon'
          style = 'icon', -- | 'underline' | 'none',
        },
        buffer_close_icon = '󰅖',
        modified_icon = '●',
        close_icon = '',
        left_trunc_marker = '',
        right_trunc_marker = '',
        max_name_length = 30,
        max_prefix_length = 30, -- prefix used when a buffer is de-duplicated
        truncate_names = true, -- whether or not tab names should be truncated
        tab_size = 21,
        diagnostics = 'nvim_lsp', -- | "nvim_lsp" | "coc",
        diagnostics_update_in_insert = false,
        -- The diagnostics indicator can be set to nil to keep the buffer name highlight but delete the highlighting
        diagnostics_indicator = function(count, level, diagnostics_dict, context)
          local icon = level:match('error') and ' ' or ' '
          return ' ' .. icon .. count
        end,
        color_icons = true, -- whether or not to add the filetype icon highlights
        show_buffer_icons = true, -- disable filetype icons for buffers
        show_buffer_close_icons = true,
        show_close_icon = true,
        show_tab_indicators = true,
        show_duplicate_prefix = true, -- whether to show duplicate buffer prefix
        persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
        move_wraps_at_ends = false, -- whether or not the move command "wraps" at the first or last position
        separator_style = 'slant', -- | "slope" | "thick" | "thin" | { 'any', 'any' },
        enforce_regular_tabs = false,
        always_show_bufferline = true,
        hover = {
          enabled = true,
          delay = 200,
          reveal = { 'close' },
        },
        sort_by = 'insert_after_current', -- |'insert_at_end' | 'id' | 'extension' | 'relative_directory' | 'directory' | 'tabs' | function(buffer_a, buffer_b)
        
        -- Transparency and visual settings
        highlights = {
          fill = {
            bg = 'NONE',
          },
          background = {
            bg = 'NONE',
          },
          tab = {
            bg = 'NONE',
          },
          tab_selected = {
            bg = '#2d333b',
          },
          tab_separator = {
            bg = 'NONE',
          },
          tab_separator_selected = {
            bg = '#2d333b',
          },
          tab_close = {
            bg = 'NONE',
          },
          close_button = {
            bg = 'NONE',
          },
          close_button_visible = {
            bg = 'NONE',
          },
          close_button_selected = {
            bg = '#2d333b',
          },
          buffer_selected = {
            bg = '#2d333b',
            bold = true,
            italic = false,
          },
          buffer_visible = {
            bg = 'NONE',
          },
          numbers = {
            bg = 'NONE',
          },
          numbers_visible = {
            bg = 'NONE',
          },
          numbers_selected = {
            bg = '#2d333b',
            bold = true,
          },
          diagnostic = {
            bg = 'NONE',
          },
          diagnostic_visible = {
            bg = 'NONE',
          },
          diagnostic_selected = {
            bg = '#2d333b',
            bold = true,
          },
          hint = {
            bg = 'NONE',
          },
          hint_visible = {
            bg = 'NONE',
          },
          hint_selected = {
            bg = '#2d333b',
          },
          hint_diagnostic = {
            bg = 'NONE',
          },
          hint_diagnostic_visible = {
            bg = 'NONE',
          },
          hint_diagnostic_selected = {
            bg = '#2d333b',
          },
          info = {
            bg = 'NONE',
          },
          info_visible = {
            bg = 'NONE',
          },
          info_selected = {
            bg = '#2d333b',
          },
          info_diagnostic = {
            bg = 'NONE',
          },
          info_diagnostic_visible = {
            bg = 'NONE',
          },
          info_diagnostic_selected = {
            bg = '#2d333b',
          },
          warning = {
            bg = 'NONE',
          },
          warning_visible = {
            bg = 'NONE',
          },
          warning_selected = {
            bg = '#2d333b',
          },
          warning_diagnostic = {
            bg = 'NONE',
          },
          warning_diagnostic_visible = {
            bg = 'NONE',
          },
          warning_diagnostic_selected = {
            bg = '#2d333b',
          },
          error = {
            bg = 'NONE',
          },
          error_visible = {
            bg = 'NONE',
          },
          error_selected = {
            bg = '#2d333b',
          },
          error_diagnostic = {
            bg = 'NONE',
          },
          error_diagnostic_visible = {
            bg = 'NONE',
          },
          error_diagnostic_selected = {
            bg = '#2d333b',
          },
          modified = {
            bg = 'NONE',
          },
          modified_visible = {
            bg = 'NONE',
          },
          modified_selected = {
            bg = '#2d333b',
          },
          duplicate_selected = {
            bg = '#2d333b',
            italic = false,
          },
          duplicate_visible = {
            bg = 'NONE',
            italic = true,
          },
          duplicate = {
            bg = 'NONE',
            italic = true,
          },
          separator_selected = {
            bg = '#2d333b',
          },
          separator_visible = {
            bg = 'NONE',
          },
          separator = {
            bg = 'NONE',
          },
          indicator_visible = {
            bg = 'NONE',
          },
          indicator_selected = {
            bg = '#2d333b',
          },
          pick_selected = {
            bg = '#2d333b',
            bold = true,
          },
          pick_visible = {
            bg = 'NONE',
            bold = true,
          },
          pick = {
            bg = 'NONE',
            bold = true,
          },
          offset_separator = {
            bg = 'NONE',
          },
          trunc_marker = {
            bg = 'NONE',
          },
        },
      },
    }
    
    -- Buffer navigation keymaps
    vim.keymap.set('n', '<S-h>', '<cmd>BufferLineCyclePrev<cr>', { desc = 'Prev Buffer' })
    vim.keymap.set('n', '<S-l>', '<cmd>BufferLineCycleNext<cr>', { desc = 'Next Buffer' })
    vim.keymap.set('n', '[b', '<cmd>BufferLineCyclePrev<cr>', { desc = 'Prev Buffer' })
    vim.keymap.set('n', ']b', '<cmd>BufferLineCycleNext<cr>', { desc = 'Next Buffer' })
    vim.keymap.set('n', '<leader>bp', '<cmd>BufferLineTogglePin<cr>', { desc = 'Toggle Pin' })
    vim.keymap.set('n', '<leader>bP', '<cmd>BufferLineGroupClose ungrouped<cr>', { desc = 'Delete Non-Pinned buffers' })
    vim.keymap.set('n', '<leader>bo', '<cmd>BufferLineCloseOthers<cr>', { desc = 'Delete Other Buffers' })
    vim.keymap.set('n', '<leader>br', '<cmd>BufferLineCloseRight<cr>', { desc = 'Delete Buffers to the Right' })
    vim.keymap.set('n', '<leader>bl', '<cmd>BufferLineCloseLeft<cr>', { desc = 'Delete Buffers to the Left' })
    vim.keymap.set('n', '<leader>bse', '<cmd>BufferLineSortByExtension<cr>', { desc = 'Sort by Extension' })
    vim.keymap.set('n', '<leader>bsd', '<cmd>BufferLineSortByDirectory<cr>', { desc = 'Sort by Directory' })
    
    -- Pick buffer
    vim.keymap.set('n', '<leader>bs', '<cmd>BufferLinePick<cr>', { desc = 'Pick Buffer' })
  end,
}
