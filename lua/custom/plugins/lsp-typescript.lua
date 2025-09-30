return {
  -- Mason: manage LSP servers
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    opts = {
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗"
        }
      }
    },
  },

  -- Mason LSP bridge
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = { "ts_ls", "eslint", "jsonls", "html", "cssls" },
      automatic_installation = true,
    },
  },

  -- Modern TypeScript/JavaScript LSP setup
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { 
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      
      -- Enhanced capabilities
      capabilities.textDocument.completion.completionItem.snippetSupport = true
      capabilities.textDocument.completion.completionItem.resolveSupport = {
        properties = { "documentation", "detail", "additionalTextEdits" }
      }

      -- Modern LSP attach function
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          local bufnr = ev.buf
          
          -- Enable inlay hints if supported (Neovim 0.10+)
          if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
            vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
          end

          local bufmap = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc, silent = true })
          end

          -- General LSP keymaps
          bufmap("n", "gd", vim.lsp.buf.definition, "Go to definition")
          bufmap("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
          bufmap("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
          bufmap("n", "gt", vim.lsp.buf.type_definition, "Go to type definition")
          bufmap("n", "gr", vim.lsp.buf.references, "References")
          bufmap("n", "K", vim.lsp.buf.hover, "Hover docs")
          bufmap("n", "<C-k>", vim.lsp.buf.signature_help, "Signature help")
          bufmap("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
          bufmap({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code actions")
          bufmap("n", "<leader>f", function()
            vim.lsp.buf.format { async = true }
          end, "Format file")
          
          -- Workspace commands
          bufmap("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, "Add workspace folder")
          bufmap("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, "Remove workspace folder")
          bufmap("n", "<leader>wl", function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, "List workspace folders")

          -- TypeScript-specific commands
          if client and client.name == "ts_ls" then
            bufmap("n", "<leader>oi", function()
              vim.lsp.buf.code_action({
                apply = true,
                context = {
                  only = { "source.organizeImports.ts" },
                  diagnostics = {},
                },
              })
            end, "Organize Imports")
            
            bufmap("n", "<leader>ru", function()
              vim.lsp.buf.code_action({
                apply = true,
                context = {
                  only = { "source.removeUnused.ts" },
                  diagnostics = {},
                },
              })
            end, "Remove unused imports")
            
            bufmap("n", "<leader>rf", function()
              local params = vim.lsp.util.make_position_params(0)
              vim.lsp.buf_request(bufnr, "workspace/executeCommand", {
                command = "_typescript.applyRenameFile",
                arguments = {
                  {
                    sourceUri = params.textDocument.uri,
                    targetUri = vim.fn.input("New path: ", params.textDocument.uri),
                  },
                },
              })
            end, "Rename file")
          end
        end,
      })

            -- Server configurations
      local servers = {
        ts_ls = {
          capabilities = capabilities,
          settings = {
            typescript = {
              inlayHints = {
                includeInlayParameterNameHints = "literal",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = false,
                includeInlayVariableTypeHints = false,
                includeInlayPropertyDeclarationTypeHints = false,
                includeInlayFunctionLikeReturnTypeHints = false,
                includeInlayEnumMemberValueHints = false,
              },
            },
            javascript = {
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
          },
        },
        
        eslint = {
          capabilities = capabilities,
          settings = {
            codeAction = {
              disableRuleComment = {
                enable = true,
                location = "separateLine"
              },
              showDocumentation = {
                enable = true
              }
            },
            codeActionOnSave = {
              enable = false,
              mode = "all"
            },
            format = true,
            nodePath = "",
            onIgnoredFiles = "off",
            packageManager = "npm",
            quiet = false,
            rulesCustomizations = {},
            run = "onType",
            useESLintClass = false,
            validate = "on",
            workingDirectory = { mode = "location" }
          },
        },
        
        jsonls = {
          capabilities = capabilities,
          settings = {
            json = {
              schemas = require('schemastore').json.schemas(),
              validate = { enable = true },
            },
          },
        },
        
        html = {
          capabilities = capabilities,
        },
        
        cssls = {
          capabilities = capabilities,
        },
      }

      -- Setup all servers
      for server, config in pairs(servers) do
        lspconfig[server].setup(config)
      end
    end,
  },

  -- JSON schemas for better JSON editing
  {
    "b0o/schemastore.nvim",
    lazy = true,
  },
}
