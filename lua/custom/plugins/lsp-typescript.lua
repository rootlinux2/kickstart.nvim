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
        ensure_installed = { "ts_ls" }, -- match typescript.nvim default
      })
    end,
  },

  -- TypeScript/JavaScript LSP + helpers
  {
    "jose-elias-alvarez/typescript.nvim",
    dependencies = { "neovim/nvim-lspconfig" },
    config = function()
      local ts = require("typescript")
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

        -- TypeScript-specific keymaps (only for ts_ls)
        if client.name == "ts_ls" then
          bufmap("n", "<leader>oi", ts.organize_imports, "Organize Imports")
          bufmap("n", "<leader>ru", ts.remove_unused, "Remove unused")
          bufmap("n", "<leader>rf", ts.rename_file, "Rename file")
        end
      end

      ts.setup({
        server = {
          capabilities = capabilities,
          on_attach = on_attach,
        },
      })
    end,
  },
}
