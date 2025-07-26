return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'rcarriga/nvim-dap-ui',
    'nvim-neotest/nvim-nio',
    'theHamsta/nvim-dap-virtual-text',
    'mxsdev/nvim-dap-vscode-js',
    {
      'microsoft/vscode-js-debug',
      opt = true,
      run = 'npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out',
    },
  },
  config = function()
    local dap = require('dap')
    local dapui = require('dapui')

    -- Setup DAP UI
    dapui.setup({
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
        },
      },
    })

    -- Setup virtual text
    require('nvim-dap-virtual-text').setup({
      enabled = true,
      enabled_commands = true,
      highlight_changed_variables = true,
      highlight_new_as_changed = false,
      show_stop_reason = true,
      commented = false,
      only_first_definition = true,
      all_references = false,
      clear_on_continue = false,
      display_callback = function(variable, buf, stackframe, node, options)
        if options.virt_text_pos == 'inline' then
          return ' = ' .. variable.value
        else
          return variable.name .. ' = ' .. variable.value
        end
      end,
    })

    -- Setup vscode-js-debug adapter
    require('dap-vscode-js').setup({
      node_path = 'node',
      debugger_path = vim.fn.stdpath('data') .. '/lazy/vscode-js-debug',
      adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' },
    })

    -- Check if we're in a Yarn PnP project
    local function is_yarn_pnp_project()
      local cwd = vim.fn.getcwd()
      return vim.fn.filereadable(cwd .. '/.pnp.cjs') == 1 or vim.fn.filereadable(cwd .. '/.pnp.js') == 1
    end

    -- Configure for different JS/TS environments
    for _, language in ipairs({ 'typescript', 'javascript', 'typescriptreact', 'javascriptreact' }) do
      dap.configurations[language] = {
        -- Debug single Node.js files
        {
          type = 'pwa-node',
          request = 'launch',
          name = 'Launch file',
          program = '${file}',
          cwd = '${workspaceFolder}',
          runtimeExecutable = is_yarn_pnp_project() and 'yarn' or 'node',
          runtimeArgs = is_yarn_pnp_project() and { 'node' } or nil,
        },
        -- Debug Node.js processes (attach to running process)
        {
          type = 'pwa-node',
          request = 'attach',
          name = 'Attach',
          processId = require('dap.utils').pick_process,
          cwd = '${workspaceFolder}',
        },
        -- Debug Jest tests
        {
          type = 'pwa-node',
          request = 'launch',
          name = 'Debug Jest Tests',
          runtimeExecutable = is_yarn_pnp_project() and 'yarn' or 'node',
          runtimeArgs = is_yarn_pnp_project() 
            and { 'test', '--inspect-brk', '--no-coverage', '--watchAll=false', '--testNamePattern', '${input:testNamePattern}' }
            or { './node_modules/.bin/jest', '--runInBand', '--no-coverage', '--watchAll=false', '--testNamePattern', '${input:testNamePattern}' },
          rootPath = '${workspaceFolder}',
          cwd = '${workspaceFolder}',
          console = 'integratedTerminal',
          internalConsoleOptions = 'neverOpen',
        },
        -- Debug Nest.js applications
        {
          type = 'pwa-node',
          request = 'launch',
          name = 'Debug Nest.js App',
          program = '${workspaceFolder}/src/main.ts',
          cwd = '${workspaceFolder}',
          runtimeExecutable = is_yarn_pnp_project() and 'yarn' or 'node',
          runtimeArgs = is_yarn_pnp_project() and { 'start:debug' } or { '-r', 'ts-node/register' },
          env = {
            NODE_ENV = 'development',
          },
          restart = true,
          console = 'integratedTerminal',
          internalConsoleOptions = 'neverOpen',
        },
        -- Debug Express.js applications
        {
          type = 'pwa-node',
          request = 'launch',
          name = 'Debug Express App',
          program = '${workspaceFolder}/src/app.js', -- or app.ts
          cwd = '${workspaceFolder}',
          runtimeExecutable = is_yarn_pnp_project() and 'yarn' or 'node',
          runtimeArgs = is_yarn_pnp_project() and { 'start' } or nil,
          env = {
            NODE_ENV = 'development',
          },
          restart = true,
          console = 'integratedTerminal',
          internalConsoleOptions = 'neverOpen',
        },
      }
    end

    -- Input configurations for Jest
    dap.configurations.javascript = vim.list_extend(dap.configurations.javascript or {}, {
      {
        type = 'pwa-node',
        request = 'launch',
        name = 'Debug Current Jest Test',
        runtimeExecutable = is_yarn_pnp_project() and 'yarn' or 'node',
        runtimeArgs = is_yarn_pnp_project()
          and { 'test', '--inspect-brk', '--no-coverage', '--watchAll=false', '${relativeFile}' }
          or { './node_modules/.bin/jest', '--runInBand', '--no-coverage', '--watchAll=false', '${relativeFile}' },
        rootPath = '${workspaceFolder}',
        cwd = '${workspaceFolder}',
        console = 'integratedTerminal',
        internalConsoleOptions = 'neverOpen',
      },
    })

    -- Auto open/close DAP UI
    dap.listeners.after.event_initialized['dapui_config'] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated['dapui_config'] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited['dapui_config'] = function()
      dapui.close()
    end

    -- Keymaps for debugging
    vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint, { desc = '[D]ebug: Toggle [B]reakpoint' })
    vim.keymap.set('n', '<leader>dB', function()
      dap.set_breakpoint(vim.fn.input('Breakpoint condition: '))
    end, { desc = '[D]ebug: Set conditional [B]reakpoint' })
    vim.keymap.set('n', '<leader>dc', dap.continue, { desc = '[D]ebug: [C]ontinue' })
    vim.keymap.set('n', '<leader>dC', dap.run_to_cursor, { desc = '[D]ebug: Run to [C]ursor' })
    vim.keymap.set('n', '<leader>dg', dap.goto_, { desc = '[D]ebug: [G]o to line (no execute)' })
    vim.keymap.set('n', '<leader>di', dap.step_into, { desc = '[D]ebug: Step [I]nto' })
    vim.keymap.set('n', '<leader>dj', dap.down, { desc = '[D]ebug: Down' })
    vim.keymap.set('n', '<leader>dk', dap.up, { desc = '[D]ebug: Up' })
    vim.keymap.set('n', '<leader>dl', dap.run_last, { desc = '[D]ebug: Run [L]ast' })
    vim.keymap.set('n', '<leader>do', dap.step_out, { desc = '[D]ebug: Step [O]ut' })
    vim.keymap.set('n', '<leader>dO', dap.step_over, { desc = '[D]ebug: Step [O]ver' })
    vim.keymap.set('n', '<leader>dp', dap.pause, { desc = '[D]ebug: [P]ause' })
    vim.keymap.set('n', '<leader>dr', dap.repl.toggle, { desc = '[D]ebug: Toggle [R]EPL' })
    vim.keymap.set('n', '<leader>ds', dap.session, { desc = '[D]ebug: [S]ession' })
    vim.keymap.set('n', '<leader>dt', dap.terminate, { desc = '[D]ebug: [T]erminate' })
    vim.keymap.set('n', '<leader>du', dapui.toggle, { desc = '[D]ebug: Toggle [U]I' })
    vim.keymap.set('n', '<leader>dw', function()
      require('dap.ui.widgets').hover()
    end, { desc = '[D]ebug: [W]idgets' })
    
    -- Visual mode mappings
    vim.keymap.set({ 'n', 'v' }, '<leader>dh', function()
      require('dap.ui.widgets').hover()
    end, { desc = '[D]ebug: [H]over' })
    vim.keymap.set({ 'n', 'v' }, '<leader>dp', function()
      require('dap.ui.widgets').preview()
    end, { desc = '[D]ebug: [P]review' })
    vim.keymap.set('n', '<leader>df', function()
      local widgets = require('dap.ui.widgets')
      widgets.centered_float(widgets.frames)
    end, { desc = '[D]ebug: [F]rames' })
    vim.keymap.set('n', '<leader>ds', function()
      local widgets = require('dap.ui.widgets')
      widgets.centered_float(widgets.scopes)
    end, { desc = '[D]ebug: [S]copes' })
  end,
}
