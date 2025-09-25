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


  end,
}
