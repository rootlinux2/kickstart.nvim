return {
  "jose-elias-alvarez/null-ls.nvim", -- Plugin for linting and formatting
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local null_ls = require("null-ls")

    null_ls.setup({
      sources = {
        -- Add eslint for linting
        null_ls.builtins.diagnostics.eslint_d,
        -- Add prettier for formatting
        null_ls.builtins.formatting.prettier,
      },
    })

    -- Optional: Keymap to format the current buffer
    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = { "*.js", "*.ts", "*.jsx", "*.tsx", "*.json" },
      callback = function()
        vim.lsp.buf.format({ async = false })
      end,
    })
  end,
}
