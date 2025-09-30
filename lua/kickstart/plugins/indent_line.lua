return {
  { -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help ibl`
    main = 'ibl',
    opts = {
      indent = {
        char = '┊',
        tab_char = '┊',
        highlight = { "IblIndent" },
        smart_indent_cap = true,
      },
      whitespace = {
        highlight = { "IblWhitespace" },
        remove_blankline_trail = true,
      },
      scope = {
        enabled = true,
        char = '┃',
        highlight = { "IblScope" },
        show_start = true,
        show_end = false,
        injected_languages = false,
        priority = 1000,
        include = {
          node_type = {
            ["*"] = { "*" },
          },
        },
      },
      exclude = {
        filetypes = {
          'help',
          'dashboard',
          'NvimTree',
          'neo-tree',
          'Trouble',
          'trouble',
          'lazy',
          'mason',
          'notify',
          'toggleterm',
        },
        buftypes = {
          'terminal',
          'nofile',
          'quickfix',
          'prompt',
        },
      },
    },
  },
}
