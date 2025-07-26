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

      -- TypeScript LSP for Yarn PnP - use the correct SDK path
      local ts_sdk_path = cwd .. '/.yarn/sdks/typescript/lib/tsserver.js'
      if vim.fn.filereadable(ts_sdk_path) == 1 then
        lspconfig.ts_ls.setup({
          cmd = { 'node', ts_sdk_path, '--stdio' },
          root_dir = root_dir,
          init_options = {
            plugins = {
              {
                name = '@yarn/typescript-plugin',
                location = cwd .. '/.yarn/sdks/@yarn/typescript-plugin',
              },
            },
          },
          settings = {
            typescript = {
              enablePromptUseWorkspaceTsdk = true,
            },
          },
        })
      else
        -- Fallback to yarn tsc wrapper
        lspconfig.ts_ls.setup({
          cmd = { 'yarn', 'dlx', '@vtsls/language-server', '--stdio' },
          root_dir = root_dir,
          settings = {
            typescript = {
              enablePromptUseWorkspaceTsdk = true,
            },
          },
        })
      end

      -- Disable auto-installation for Yarn PnP projects
      vim.notify('Yarn PnP LSP configuration loaded for: ' .. vim.fn.fnamemodify(cwd, ':t'), vim.log.levels.INFO)
    end
  end,
}
