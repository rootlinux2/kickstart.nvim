-- Modern LSP client utilities
-- Replaces any deprecated vim.lsp functions with modern equivalents

local M = {}

-- Modern replacement for vim.lsp.buf_get_clients() and vim.lsp.get_active_clients()
function M.get_clients(bufnr)
  if vim.lsp.get_clients then
    -- Modern API (Neovim 0.10+)
    return vim.lsp.get_clients({ bufnr = bufnr })
  else
    -- Fallback for older versions
    return vim.lsp.buf_get_clients(bufnr)
  end
end

-- Get all active LSP clients
function M.get_active_clients()
  if vim.lsp.get_clients then
    -- Modern API (Neovim 0.10+)
    return vim.lsp.get_clients()
  else
    -- Fallback for older versions
    return vim.lsp.get_active_clients()
  end
end

-- Modern way to check if LSP is attached to buffer
function M.is_lsp_attached(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local clients = M.get_clients(bufnr)
  return #clients > 0
end

-- Get LSP client by name
function M.get_client_by_name(name, bufnr)
  local clients = M.get_clients(bufnr)
  for _, client in ipairs(clients) do
    if client.name == name then
      return client
    end
  end
  return nil
end

return M