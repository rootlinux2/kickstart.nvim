return {
  'nvim-neotest/neotest',
  dependencies = {
    'nvim-neotest/nvim-nio',
    'nvim-lua/plenary.nvim',
    'antoinemadec/FixCursorHold.nvim',
    'nvim-treesitter/nvim-treesitter',
    'nvim-neotest/neotest-jest', -- Jest adapter
  },
  config = function()
    local function is_yarn_pnp_project()
      local cwd = vim.fn.getcwd()
      return vim.fn.filereadable(cwd .. '/.pnp.cjs') == 1 or vim.fn.filereadable(cwd .. '/.pnp.js') == 1
    end

    -- Determine Jest command based on project type
    local jest_command = is_yarn_pnp_project() and 'yarn test --' or 'npm test --'

    require('neotest').setup({
      adapters = {
        require('neotest-jest')({
          jestCommand = jest_command,
          jestConfigFile = function(file)
            -- Look for common Jest config files
            local possible_configs = {
              'jest.config.js',
              'jest.config.ts',
              'jest.config.json',
              'package.json', -- if jest config is in package.json
            }
            
            for _, config in ipairs(possible_configs) do
              if vim.fn.filereadable(config) == 1 then
                return config
              end
            end
            
            return nil -- Let Jest find the config automatically
          end,
          env = { CI = true },
          cwd = function(path)
            return vim.fn.getcwd()
          end,
        }),
      },
      discovery = {
        enabled = false, -- Disable auto-discovery for better performance
      },
      diagnostic = {
        enabled = true,
      },
      floating = {
        border = 'rounded',
        max_height = 0.6,
        max_width = 0.6,
      },
      icons = {
        child_indent = '│',
        child_prefix = '├',
        collapsed = '─',
        expanded = '╮',
        failed = '✖',
        final_child_indent = ' ',
        final_child_prefix = '╰',
        non_collapsible = '─',
        passed = '✓',
        running = '',
        running_animated = { '/', '|', '\\', '-', '/', '|', '\\', '-' },
        skipped = '○',
        unknown = '?',
      },
      status = {
        enabled = true,
        signs = true,
        virtual_text = false, -- Disable virtual text to avoid clutter
      },
    })

    -- Keymaps for neotest
    local neotest = require('neotest')
    
    vim.keymap.set('n', '<leader>tr', function()
      neotest.run.run()
    end, { desc = '[T]est [R]un nearest' })
    
    vim.keymap.set('n', '<leader>tf', function()
      neotest.run.run(vim.fn.expand('%'))
    end, { desc = '[T]est [F]ile' })
    
    vim.keymap.set('n', '<leader>td', function()
      neotest.run.run({ strategy = 'dap' })
    end, { desc = '[T]est [D]ebug nearest' })
    
    vim.keymap.set('n', '<leader>ts', function()
      neotest.summary.toggle()
    end, { desc = '[T]est [S]ummary' })
    
    vim.keymap.set('n', '<leader>to', function()
      neotest.output.open({ enter = true })
    end, { desc = '[T]est [O]utput' })
    
    vim.keymap.set('n', '<leader>tp', function()
      neotest.output_panel.toggle()
    end, { desc = '[T]est [P]anel' })
    
    vim.keymap.set('n', '<leader>tw', function()
      neotest.watch.toggle()
    end, { desc = '[T]est [W]atch' })
  end,
}
