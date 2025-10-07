-- Configuration health check and startup optimization
local M = {}

-- Performance monitoring
local function profile_startup()
  local start_time = vim.loop.hrtime()
  
  vim.api.nvim_create_autocmd("VimEnter", {
    once = true,
    callback = function()
      local end_time = vim.loop.hrtime()
      local startup_time = (end_time - start_time) / 1e6 -- Convert to milliseconds
      
      -- Show startup time if over threshold
      if startup_time > 100 then
        vim.defer_fn(function()
          vim.notify(
            string.format("Startup time: %.2fms", startup_time),
            vim.log.levels.WARN,
            { title = "Performance" }
          )
        end, 100)
      end
    end,
  })
end

-- Health checks
function M.check_health()
  local health = {}
  
  -- Check Neovim version
  health.nvim_version = vim.version()
  health.nvim_ok = vim.version().major >= 0 and vim.version().minor >= 9
  
  -- Check for required tools
  local tools = {
    'git', 'node', 'npm', 'ripgrep', 'fd', 'fzf'
  }
  
  health.tools = {}
  for _, tool in ipairs(tools) do
    health.tools[tool] = vim.fn.executable(tool) == 1
  end
  
  -- Check LSP servers
  health.lsp_servers = {}
  local servers = { 'typescript-language-server', 'lua-language-server', 'prettier' }
  for _, server in ipairs(servers) do
    health.lsp_servers[server] = vim.fn.executable(server) == 1
  end
  
  -- Check plugin count
  local lazy_stats = require("lazy").stats()
  health.plugin_count = lazy_stats.count
  health.plugin_loaded = lazy_stats.loaded
  
  -- Print health report
  print("=== Neovim Configuration Health Check ===")
  print(string.format("Neovim version: %s (%s)", 
    vim.version().major .. "." .. vim.version().minor .. "." .. vim.version().patch,
    health.nvim_ok and "✓" or "✗"))
  
  print("\nTools:")
  for tool, available in pairs(health.tools) do
    print(string.format("  %s: %s", tool, available and "✓" or "✗"))
  end
  
  print("\nLSP Servers:")
  for server, available in pairs(health.lsp_servers) do
    print(string.format("  %s: %s", server, available and "✓" or "✗"))
  end
  
  print(string.format("\nPlugins: %d total, %d loaded", health.plugin_count, health.plugin_loaded))
  
  return health
end

-- Cleanup function for performance
function M.cleanup()
  -- Clear unnecessary highlights
  vim.cmd("nohlsearch")
  
  -- Clean up unused buffers
  local current_buf = vim.api.nvim_get_current_buf()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if buf ~= current_buf and vim.api.nvim_buf_is_loaded(buf) then
      local buf_name = vim.api.nvim_buf_get_name(buf)
      if buf_name == "" or not vim.bo[buf].modified then
        vim.api.nvim_buf_delete(buf, { force = false })
      end
    end
  end
  
  -- Force garbage collection
  collectgarbage("collect")
  
  vim.notify("Cleanup completed", vim.log.levels.INFO)
end

-- Development mode toggle
function M.toggle_dev_mode()
  local dev_mode = vim.g.dev_mode or false
  vim.g.dev_mode = not dev_mode
  
  if vim.g.dev_mode then
    -- Enable development features
    vim.opt.number = true
    vim.opt.relativenumber = true
    vim.opt.signcolumn = "yes"
    vim.opt.cursorline = true
    vim.opt.colorcolumn = "80,120"
    
    -- Enable LSP logging
    vim.lsp.set_log_level("debug")
    
    vim.notify("Development mode enabled", vim.log.levels.INFO)
  else
    -- Disable development features for better performance
    vim.opt.relativenumber = false
    vim.opt.cursorline = false
    vim.opt.colorcolumn = ""
    
    -- Disable LSP logging
    vim.lsp.set_log_level("warn")
    
    vim.notify("Development mode disabled", vim.log.levels.INFO)
  end
end

-- Quick config reload
function M.reload_config()
  -- Clear module cache
  for name, _ in pairs(package.loaded) do
    if name:match("^config") or name:match("^custom") then
      package.loaded[name] = nil
    end
  end
  
  -- Reload configuration
  dofile(vim.env.MYVIMRC)
  vim.notify("Configuration reloaded", vim.log.levels.INFO)
end

-- Keymaps for utility functions
vim.keymap.set('n', '<leader>ch', M.check_health, { desc = 'Check configuration health' })
vim.keymap.set('n', '<leader>cc', M.cleanup, { desc = 'Cleanup and optimize' })
vim.keymap.set('n', '<leader>cd', M.toggle_dev_mode, { desc = 'Toggle development mode' })
vim.keymap.set('n', '<leader>cr', M.reload_config, { desc = 'Reload configuration' })

-- Auto-cleanup on exit
vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = function()
    -- Save session if auto-session is available
    if pcall(require, "auto-session") then
      require("auto-session").SaveSession()
    end
    
    -- Quick cleanup
    collectgarbage("collect")
  end,
})

-- Performance monitoring
if vim.g.performance_mode ~= false then
  profile_startup()
end

return M