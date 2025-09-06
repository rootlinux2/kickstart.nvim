-- Enhanced LSP configuration with additional servers and improvements
return {
  -- Additional LSP servers you might want to consider
  {
    "neovim/nvim-lspconfig",
    dependencies = { "williamboman/mason-lspconfig.nvim" },
    config = function()
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Enhanced capabilities for better LSP experience
      capabilities.textDocument.completion.completionItem.snippetSupport = true
      capabilities.textDocument.completion.completionItem.resolveSupport = {
        properties = { "documentation", "detail", "additionalTextEdits" }
      }

      local on_attach = function(client, bufnr)
        -- Enable inlay hints if available (Neovim 0.10+)
        if client.supports_method("textDocument/inlayHint") then
          vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
        end

        -- Additional LSP servers you might want to add
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
            capabilities = capabilities,
          },
          
          -- CSS
          cssls = {
            capabilities = capabilities,
          },
          
          -- Lua (for Neovim configuration)
          lua_ls = {
            settings = {
              Lua = {
                runtime = { version = "LuaJIT" },
                workspace = {
                  checkThirdParty = false,
                  library = { vim.env.VIMRUNTIME },
                },
                completion = { callSnippet = "Replace" },
                diagnostics = { disable = { "missing-fields" } },
              },
            },
          },
        }

        -- Setup servers with enhanced configurations
        for server, config in pairs(servers) do
          config.capabilities = capabilities
          config.on_attach = on_attach
          lspconfig[server].setup(config)
        end
      end
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
      })
    end,
  },
}
