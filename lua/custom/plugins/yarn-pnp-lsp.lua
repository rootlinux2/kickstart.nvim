return {
  'neovim/nvim-lspconfig',
  dependencies = {
    'mason-org/mason.nvim',
    'mason-org/mason-lspconfig.nvim',
  },
  config = function()
    local lspconfig = require('lspconfig')
    local util = require('lspconfig.util')

    -- Root detection function for Yarn PnP projects
    local root_files = {
      '.pnp.cjs',
      '.pnp.js',
      'yarn.lock',
      '.yarnrc.yml',
      '.eslintrc.js',
      '.eslintrc.json',
      'package.json',
      '.git',
    }

    local function is_yarn_pnp_project()
      local cwd = vim.fn.getcwd()
      return vim.fn.filereadable(cwd .. '/.pnp.cjs') == 1 or vim.fn.filereadable(cwd .. '/.pnp.js') == 1
    end

    local root_dir = util.root_pattern(unpack(root_files))

    -- Only configure Yarn PnP LSPs if we're in a Yarn PnP project
    if is_yarn_pnp_project() then
      local cwd = vim.fn.getcwd()
      
      -- ESLint LSP for Yarn PnP - use yarn eslint directly
      lspconfig.eslint.setup({
        cmd = { 'yarn', 'eslint', '--stdio' },
        root_dir = root_dir,
        settings = {
          validate = 'on',
          packageManager = 'yarn',
          useESLintClass = true,
        },
        on_attach = function(client, bufnr)
          vim.api.nvim_create_autocmd('BufWritePre', {
            buffer = bufnr,
            command = 'EslintFixAll',
          })
        end,
      })

      -- TypeScript LSP for Yarn PnP - use vtsls instead of ts_ls for better PnP support
      lspconfig.vtsls.setup({
        root_dir = root_dir,
        settings = {
          vtsls = {
            tsserver = {
              globalPlugins = {
                {
                  name = '@yarn/typescript-plugin',
                  location = cwd .. '/.yarn/sdks/@yarn/typescript-plugin',
                  enableForWorkspaceTypeScriptVersions = true,
                },
              },
            },
            typescript = {
              updateImportsOnFileMove = { enabled = 'always' },
              suggest = {
                completeFunctionCalls = true,
              },
              inlayHints = {
                enumMemberValues = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
                parameterNames = { enabled = 'literals' },
                parameterTypes = { enabled = true },
                propertyDeclarationTypes = { enabled = true },
                variableTypes = { enabled = false },
              },
            },
          },
        },
        -- Handle the typingsInstallerPid event
        handlers = {
          ['typingsInstallerPid'] = function(err, result, ctx, config)
            -- Silently ignore this event as it's not critical for functionality
            return true
          end,
        },
        on_attach = function(client, bufnr)
          -- Disable formatting if you're using prettier or another formatter
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
        end,
      })

      -- Disable auto-installation for Yarn PnP projects
      vim.notify('Yarn PnP LSP configuration loaded for: ' .. vim.fn.fnamemodify(cwd, ':t'), vim.log.levels.INFO)
    end
  end,
}
