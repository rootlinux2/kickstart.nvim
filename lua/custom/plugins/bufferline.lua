return {
  'akinsho/bufferline.nvim',
  version = '*',
  dependencies = 'nvim-tree/nvim-web-devicons',
  config = function()
    -- Get colors from the current colorscheme
    local function get_highlight_color(group, attr)
      local hl = vim.api.nvim_get_hl(0, { name = group })
      if attr == 'fg' then
        return hl.fg and string.format("#%06x", hl.fg) or nil
      elseif attr == 'bg' then
        return hl.bg and string.format("#%06x", hl.bg) or nil
      end
    end

    require('bufferline').setup {
      options = {
        mode = 'buffers',
        style_preset = require('bufferline').style_preset.minimal,
        themable = false, -- Disable themable to use our custom highlights
        numbers = 'none',
        close_command = 'bdelete! %d',
        right_mouse_command = 'bdelete! %d',
        left_mouse_command = 'buffer %d',
        middle_mouse_command = nil,
        indicator = {
          icon = '▎',
          style = 'icon',
        },
        buffer_close_icon = '󰅖',
        modified_icon = '●',
        close_icon = '',
        left_trunc_marker = '',
        right_trunc_marker = '',
        max_name_length = 30,
        max_prefix_length = 30,
        truncate_names = true,
        tab_size = 21,
        diagnostics = 'nvim_lsp',
        diagnostics_update_in_insert = false,
        diagnostics_indicator = function(count, level, diagnostics_dict, context)
          local icon = level:match('error') and ' ' or ' '
          return ' ' .. icon .. count
        end,
        color_icons = true,
        show_buffer_icons = true,
        show_buffer_close_icons = true,
        show_close_icon = true,
        show_tab_indicators = true,
        show_duplicate_prefix = true,
        persist_buffer_sort = true,
        move_wraps_at_ends = false,
        separator_style = 'thin',
        enforce_regular_tabs = false,
        always_show_bufferline = true,
        hover = {
          enabled = true,
          delay = 200,
          reveal = { 'close' },
        },
        sort_by = 'insert_after_current',
        
        -- Completely transparent setup
        highlights = {
          fill = {
            bg = 'NONE',
          },
          background = {
            bg = 'NONE',
            fg = get_highlight_color('Comment', 'fg') or '#565f89',
          },
          buffer_visible = {
            bg = 'NONE',
            fg = get_highlight_color('Normal', 'fg') or '#c0caf5',
          },
          buffer_selected = {
            bg = 'NONE', -- Completely transparent
            fg = get_highlight_color('Normal', 'fg') or '#c0caf5',
            bold = true,
            italic = false,
          },
          close_button = {
            bg = 'NONE',
            fg = get_highlight_color('Comment', 'fg') or '#565f89',
          },
          close_button_visible = {
            bg = 'NONE',
            fg = get_highlight_color('Comment', 'fg') or '#565f89',
          },
          close_button_selected = {
            bg = 'NONE',
            fg = get_highlight_color('Normal', 'fg') or '#c0caf5',
          },
          separator = {
            bg = 'NONE',
            fg = 'NONE',
          },
          separator_visible = {
            bg = 'NONE',
            fg = 'NONE',
          },
          separator_selected = {
            bg = 'NONE',
            fg = 'NONE',
          },
          indicator_visible = {
            bg = 'NONE',
            fg = get_highlight_color('Comment', 'fg') or '#565f89',
          },
          indicator_selected = {
            bg = 'NONE',
            fg = get_highlight_color('DiagnosticHint', 'fg') or '#1abc9c',
          },
          modified = {
            bg = 'NONE',
            fg = get_highlight_color('DiagnosticWarn', 'fg') or '#e0af68',
          },
          modified_visible = {
            bg = 'NONE',
            fg = get_highlight_color('DiagnosticWarn', 'fg') or '#e0af68',
          },
          modified_selected = {
            bg = 'NONE',
            fg = get_highlight_color('DiagnosticWarn', 'fg') or '#e0af68',
          },
          duplicate = {
            bg = 'NONE',
            fg = get_highlight_color('Comment', 'fg') or '#565f89',
            italic = true,
          },
          duplicate_visible = {
            bg = 'NONE',
            fg = get_highlight_color('Comment', 'fg') or '#565f89',
            italic = true,
          },
          duplicate_selected = {
            bg = 'NONE',
            fg = get_highlight_color('Normal', 'fg') or '#c0caf5',
            italic = false,
          },
          error = {
            bg = 'NONE',
            fg = get_highlight_color('DiagnosticError', 'fg') or '#f7768e',
          },
          error_visible = {
            bg = 'NONE',
            fg = get_highlight_color('DiagnosticError', 'fg') or '#f7768e',
          },
          error_selected = {
            bg = 'NONE',
            fg = get_highlight_color('DiagnosticError', 'fg') or '#f7768e',
          },
          warning = {
            bg = 'NONE',
            fg = get_highlight_color('DiagnosticWarn', 'fg') or '#e0af68',
          },
          warning_visible = {
            bg = 'NONE',
            fg = get_highlight_color('DiagnosticWarn', 'fg') or '#e0af68',
          },
          warning_selected = {
            bg = 'NONE',
            fg = get_highlight_color('DiagnosticWarn', 'fg') or '#e0af68',
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
