return {
  -- Mason: manage LSP servers
  {
    "williamboman/mason.nvim",
    config = true,
    build = function()
      pcall(vim.cmd, "MasonUpdate")
    end,
  },

  -- Mason LSP bridge
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "ts_ls" },
      })
    end,
  },

  -- Modern TypeScript/JavaScript LSP setup
  {
    "neovim/nvim-lspconfig",
    dependencies = { "williamboman/mason-lspconfig.nvim" },
    config = function()
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      local on_attach = function(client, bufnr)
        local bufmap = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end

        -- General LSP keymaps
        bufmap("n", "gd", vim.lsp.buf.definition, "Go to definition")
        bufmap("n", "gr", vim.lsp.buf.references, "References")
        bufmap("n", "K", vim.lsp.buf.hover, "Hover docs")
        bufmap("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
        bufmap("n", "<leader>ca", vim.lsp.buf.code_action, "Code actions")
        bufmap("n", "<leader>f", function()
          vim.lsp.buf.format { async = true }
        end, "Format file")

        -- TypeScript-specific commands via code actions
        if client.name == "ts_ls" then
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
            local params = vim.lsp.util.make_position_params()
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
      end

      -- Setup ts_ls with proper configuration
      lspconfig.ts_ls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
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
              includeInlayFunctionParameterTypeHints = false,
              includeInlayVariableTypeHints = false,
              includeInlayPropertyDeclarationTypeHints = false,
              includeInlayFunctionLikeReturnTypeHints = false,
              includeInlayEnumMemberValueHints = false,
            },
          },
        },
      })
    end,
  },
}
