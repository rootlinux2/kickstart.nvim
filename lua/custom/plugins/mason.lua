return {
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate", -- updates registry
    config = true,
  },
  -- Mason LSP integration is now handled in lsp-typescript.lua
}
