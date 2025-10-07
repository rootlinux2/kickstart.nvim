-- Enhanced LSP configuration with additional servers and improvements
return {
  -- Additional LSP servers you might want to consider
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { 
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp"
    },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Enhanced capabilities for better LSP experience
      capabilities.textDocument.completion.completionItem.snippetSupport = true
      capabilities.textDocument.completion.completionItem.resolveSupport = {
        properties = { "documentation", "detail", "additionalTextEdits" }
      }
      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true
      }

      -- Performance optimizations
      local lsp_flags = {
        allow_incremental_sync = true,
        debounce_text_changes = 150,
      }

      local on_attach = function(client, bufnr)
        -- Performance: disable semantic tokens for large files
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(bufnr))
        if ok and stats and stats.size > max_filesize then
          client.server_capabilities.semanticTokensProvider = nil
        end

        -- Enable inlay hints if available (Neovim 0.10+)
        if client.supports_method("textDocument/inlayHint") then
          vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
        end

        -- Enhanced LSP keymaps
        local km = vim.keymap.set
        local opts = { buffer = bufnr, noremap = true, silent = true }
        
        km('n', 'gd', vim.lsp.buf.definition, vim.tbl_extend('force', opts, { desc = 'Goto Definition' }))
        km('n', 'gr', vim.lsp.buf.references, vim.tbl_extend('force', opts, { desc = 'Goto References' }))
        km('n', 'gD', vim.lsp.buf.declaration, vim.tbl_extend('force', opts, { desc = 'Goto Declaration' }))
        km('n', 'gI', vim.lsp.buf.implementation, vim.tbl_extend('force', opts, { desc = 'Goto Implementation' }))
        km('n', 'gt', vim.lsp.buf.type_definition, vim.tbl_extend('force', opts, { desc = 'Type Definition' }))
        km('n', 'K', vim.lsp.buf.hover, vim.tbl_extend('force', opts, { desc = 'Hover Documentation' }))
        km('n', 'gK', vim.lsp.buf.signature_help, vim.tbl_extend('force', opts, { desc = 'Signature Documentation' }))
        km('i', '<C-k>', vim.lsp.buf.signature_help, vim.tbl_extend('force', opts, { desc = 'Signature Documentation' }))
        
        -- Code actions and refactoring
        km({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, vim.tbl_extend('force', opts, { desc = 'Code Action' }))
        km('n', '<leader>cr', vim.lsp.buf.rename, vim.tbl_extend('force', opts, { desc = 'Rename' }))
        km('n', '<leader>cf', function()
          vim.lsp.buf.format({ async = true })
        end, vim.tbl_extend('force', opts, { desc = 'Format Document' }))
        
        -- Workspace
        km('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, vim.tbl_extend('force', opts, { desc = 'Workspace Add Folder' }))
        km('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, vim.tbl_extend('force', opts, { desc = 'Workspace Remove Folder' }))
        km('n', '<leader>wl', function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, vim.tbl_extend('force', opts, { desc = 'Workspace List Folders' }))
        
        -- Toggle inlay hints
        if client.supports_method("textDocument/inlayHint") then
          km('n', '<leader>th', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
          end, vim.tbl_extend('force', opts, { desc = 'Toggle Inlay Hints' }))
        end
      end

      -- Setup additional LSP servers using lspconfig
      local servers = {
        -- JSON
        jsonls = {
          settings = {
            json = {
              schemas = require("schemastore").json.schemas(),
              validate = { enable = true },
            },
          },
        },
        
        -- HTML
        html = {
          filetypes = { 'html', 'templ' },
        },
        
        -- CSS
        cssls = {
          settings = {
            css = {
              validate = true,
              lint = {
                unknownAtRules = "ignore"
              }
            },
            scss = {
              validate = true,
              lint = {
                unknownAtRules = "ignore"
              }
            },
            less = {
              validate = true,
              lint = {
                unknownAtRules = "ignore"
              }
            },
          },
        },
        
        -- Lua (for Neovim configuration)
        lua_ls = {
          settings = {
            Lua = {
              runtime = { version = "LuaJIT" },
              workspace = {
                checkThirdParty = false,
                library = { 
                  vim.env.VIMRUNTIME,
                  "${3rd}/luv/library",
                  "${3rd}/busted/library",
                },
                maxPreload = 100000,
                preloadFileSize = 10000,
              },
              completion = { 
                callSnippet = "Replace",
                showWord = "Disable",
              },
              diagnostics = { 
                disable = { "missing-fields" },
                globals = { "vim" },
              },
              hint = {
                enable = true,
                arrayIndex = "Disable", -- Don't show array index hints
              },
              telemetry = { enable = false },
            },
          },
        },
        
        -- Docker
        dockerls = {},
        
        -- YAML
        yamlls = {
          settings = {
            yaml = {
              schemas = {
                ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
                ["https://json.schemastore.org/github-action.json"] = "/action.{yml,yaml}",
                ["https://json.schemastore.org/docker-compose.json"] = "docker-compose*.{yml,yaml}",
                ["https://json.schemastore.org/prettierrc.json"] = ".prettierrc.{yml,yaml}",
                ["https://json.schemastore.org/stylelintrc.json"] = ".stylelintrc.{yml,yaml}",
                ["https://json.schemastore.org/circleciconfig"] = "/.circleci/config.{yml,yaml}",
              },
            },
          },
        },
      }

      -- Setup servers with enhanced configurations
      for server_name, config in pairs(servers) do
        config.capabilities = capabilities
        config.on_attach = on_attach
        config.flags = lsp_flags
        require('lspconfig')[server_name].setup(config)
      end

      -- Configure diagnostic appearance
      vim.diagnostic.config({
        virtual_text = {
          prefix = '●',
          source = "if_many",
        },
        float = {
          source = "always",
          border = "rounded",
        },
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
      })

      -- Customize LSP handlers
      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = "rounded",
      })

      vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = "rounded",
      })
    end,
  },

  -- Schema store for JSON schemas
  {
    "b0o/schemastore.nvim",
    lazy = true,
  },

  -- LSP progress indicator
  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    opts = {
      notification = {
        window = {
          winblend = 100,
        },
      },
      progress = {
        poll_rate = 0,
        suppress_on_insert = true,
        ignore_done_already = true,
        ignore_empty_message = true,
      },
    },
  },

  -- Better LSP signature help
  {
    "ray-x/lsp_signature.nvim",
    event = "LspAttach",
    config = function()
      require("lsp_signature").setup({
        bind = true,
        handler_opts = {
          border = "rounded"
        },
        floating_window = true,
        hint_prefix = "🐼 ",
        hint_enable = true,
        hint_scheme = "String",
        use_lspsaga = false,
        hi_parameter = "LspSignatureActiveParameter",
        max_height = 12,
        max_width = 80,
        wrap = true,
        floating_window_above_cur_line = true,
        floating_window_off_x = 1,
        floating_window_off_y = 0,
        close_timeout = 4000,
        fix_pos = false,
        auto_close_after = nil,
        zindex = 200,
        padding = '',
        toggle_key = nil,
        select_signature_key = nil,
        move_cursor_key = nil,
      })
    end,
  },

  -- LSP lines for better diagnostic display
  {
    "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    event = "LspAttach",
    config = function()
      require("lsp_lines").setup()
      
      -- Toggle lsp_lines
      vim.keymap.set('n', '<leader>tl', function()
        local current = vim.diagnostic.config().virtual_lines
        vim.diagnostic.config({
          virtual_lines = not current,
          virtual_text = current, -- opposite of virtual_lines
        })
      end, { desc = 'Toggle LSP lines' })
      
      -- Initially disable virtual_text since we're using lsp_lines
      vim.diagnostic.config({ 
        virtual_text = false,
        virtual_lines = true 
      })
    end,
  },
}
