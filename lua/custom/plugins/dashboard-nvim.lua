return {
  'nvimdev/dashboard-nvim',
  event = 'VimEnter',
  priority = 1000, -- High priority to load before other plugins
  config = function()
    require('dashboard').setup {
      theme = 'hyper',
      disable_move = true, -- Disable default dashboard movement
      config = {
        header = {
          '',
          '██████╗  ██████╗  ██████╗ ████████╗██╗     ██╗███╗   ██╗██╗   ██╗██╗  ██╗██████╗ ',
          '██╔══██╗██╔═══██╗██╔═══██╗╚══██╔══╝██║     ██║████╗  ██║██║   ██║╚██╗██╔╝╚════██╗',
          '██████╔╝██║   ██║██║   ██║   ██║   ██║     ██║██╔██╗ ██║██║   ██║ ╚███╔╝  █████╔╝',
          '██╔══██╗██║   ██║██║   ██║   ██║   ██║     ██║██║╚██╗██║██║   ██║ ██╔██╗ ██╔═══╝ ',
          '██║  ██║╚██████╔╝╚██████╔╝   ██║   ███████╗██║██║ ╚████║╚██████╔╝██╔╝ ██╗███████╗',
          '╚═╝  ╚═╝ ╚═════╝  ╚═════╝    ╚═╝   ╚══════╝╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝',
          '',
        },
        week_header = {
          enable = false, -- Disable week header to prevent override
        },
        shortcut = {
          {
            desc = '󰊳 Update',
            group = '@property',
            action = 'Lazy update',
            key = 'u',
          },
          {
            icon = ' ',
            icon_hl = '@variable',
            desc = 'Files',
            group = 'Label',
            action = 'Telescope find_files',
            key = 'f',
          },
          {
            icon = ' ',
            desc = 'Recent',
            group = 'DiagnosticHint',
            action = 'Telescope oldfiles',
            key = 'r',
          },
          {
            icon = ' ',
            desc = 'Config',
            group = 'Number',
            action = function()
              vim.cmd 'edit ~/.config/nvim/init.lua'
            end,
            key = 'c',
          },
          {
            icon = '󰗼 ',
            desc = 'Quit',
            group = 'Error',
            action = 'qa',
            key = 'q',
          },
        },
        project = {
          enable = true,
          limit = 8,
          icon = ' ',
          label = ' Recent Projects:',
          action = 'Telescope find_files cwd=',
        },
        mru = {
          limit = 10,
          icon = ' ',
          label = ' Most Recent Files:',
        },
        footer = {
          '',
          '🚀 Ready to code!',
        },
      },
    }
    
    -- Fix vertical lines issue in dashboard
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'dashboard',
      callback = function()
        vim.opt_local.colorcolumn = ''
        vim.opt_local.signcolumn = 'no'
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
        vim.opt_local.list = false
        vim.opt_local.cursorline = false
        vim.opt_local.foldcolumn = '0'
      end,
    })
  end,
  dependencies = {
    'nvim-tree/nvim-web-devicons',
    'nvim-telescope/telescope.nvim',
  },
}