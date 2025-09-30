-- Custom health checks for your Neovim configuration
local M = {}

local health = vim.health

function M.check()
  health.start("Custom Configuration Health")
  
  -- Check Neovim version
  local version = vim.version()
  local version_str = string.format("%d.%d.%d", version.major, version.minor, version.patch)
  
  if version.major == 0 and version.minor >= 10 then
    health.ok(string.format("Neovim version: %s (modern features available)", version_str))
  elseif version.major == 0 and version.minor >= 9 then
    health.warn(string.format("Neovim version: %s (consider upgrading to 0.10+ for latest features)", version_str))
  else
    health.error(string.format("Neovim version: %s (upgrade required for this configuration)", version_str))
  end
  
  -- Check for required directories
  local dirs = {
    { path = vim.fn.stdpath('cache') .. '/undo', name = "Undo directory" },
    { path = vim.fn.stdpath('cache') .. '/backup', name = "Backup directory" },
    { path = vim.fn.stdpath('cache') .. '/swap', name = "Swap directory" },
  }
  
  for _, dir in ipairs(dirs) do
    if vim.fn.isdirectory(dir.path) == 1 then
      health.ok(string.format("%s exists: %s", dir.name, dir.path))
    else
      health.error(string.format("%s missing: %s", dir.name, dir.path))
    end
  end
  
  -- Check shell
  local shell = vim.o.shell
  if vim.fn.executable(shell) == 1 then
    health.ok(string.format("Shell is executable: %s", shell))
  else
    health.error(string.format("Shell not found or not executable: %s", shell))
  end
  
  -- Check clipboard
  if vim.fn.has('clipboard') == 1 then
    health.ok("Clipboard support available")
  else
    health.warn("Clipboard support not available")
  end
  
  -- Check for LSP executables
  local lsp_servers = { 'ts_ls', 'eslint', 'jsonls', 'html', 'cssls' }
  local mason_registry = require('mason-registry')
  
  for _, server in ipairs(lsp_servers) do
    if mason_registry.is_installed(server) then
      health.ok(string.format("LSP server installed: %s", server))
    else
      health.warn(string.format("LSP server not installed: %s", server))
    end
  end
  
  -- Check for optional tools
  local tools = {
    { cmd = 'git', name = 'Git' },
    { cmd = 'lazygit', name = 'LazyGit' },
    { cmd = 'rg', name = 'Ripgrep (for telescope)' },
    { cmd = 'fd', name = 'fd (for telescope)' },
    { cmd = 'yazi', name = 'Yazi file manager' },
  }
  
  for _, tool in ipairs(tools) do
    if vim.fn.executable(tool.cmd) == 1 then
      health.ok(string.format("%s is available", tool.name))
    else
      health.info(string.format("%s is not installed (optional)", tool.name))
    end
  end
  
  -- Check deprecated files
  local deprecated_files = {
    vim.fn.stdpath('config') .. '/lua/custom/plugins/typescript-lsp.lua',
  }
  
  for _, file in ipairs(deprecated_files) do
    if vim.fn.filereadable(file) == 1 then
      health.warn(string.format("Deprecated file still exists: %s", file))
    else
      health.ok("No deprecated configuration files found")
      break
    end
  end
end

return M