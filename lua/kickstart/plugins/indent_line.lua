return {
  { -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help ibl`
    main = 'ibl',
    opts = {
      indent = {
        char = '┊',
      },
      exclude = {
        filetypes = {
          'help',
          'dashboard',
          'NvimTree',
          'Trouble',
          'lazy',
          'mason',
        },
        buftypes = {
          'terminal',
          'nofile',
        },
      },
    },
  },
}
