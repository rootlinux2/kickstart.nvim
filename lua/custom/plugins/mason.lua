return {
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate", -- updates registry
    config = true,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup {
        ensure_installed = { "ts_ls" },
      }
    end,
  },
}
