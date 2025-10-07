-- Simple and reliable deprecation checker
local M = {}

-- Simple function to check for specific deprecated patterns
function M.quick_check()
  print("=== Quick Deprecation Check ===")
  
  local config_dir = vim.fn.stdpath('config')
  
  -- Most common deprecated patterns to check
  local patterns = {
    "vim.lsp.buf_get_clients",
    "vim.lsp.get_active_clients", 
    "vim.api.nvim_buf_get_option",
    "vim.api.nvim_buf_set_option",
    "vim.lsp.buf.formatting",
    "vim.lsp.diagnostic.show_line_diagnostics"
  }
  
  local found_issues = false
  
  for _, pattern in ipairs(patterns) do
    -- Use ripgrep if available, otherwise grep
    local cmd = vim.fn.executable('rg') == 1 
      and string.format('rg -n "%s" %s --type lua 2>/dev/null || true', pattern, config_dir)
      or string.format('grep -rn "%s" %s --include="*.lua" 2>/dev/null || true', pattern, config_dir)
    
    local result = vim.fn.system(cmd)
    
    if result ~= "" and not result:match("No such file") then
      if not found_issues then
        print("❌ Found deprecated patterns:")
        found_issues = true
      end
      print(string.format("\n🔍 Pattern: %s", pattern))
      -- Clean up the output
      for line in result:gmatch("[^\r\n]+") do
        if line ~= "" and not line:match("deprecation") then -- Skip lines from deprecation files themselves
          print("   " .. line)
        end
      end
    end
  end
  
  if not found_issues then
    print("✅ No deprecated patterns found in your configuration!")
  else
    print("\n📚 Quick Replacements:")
    print("  vim.lsp.buf_get_clients(bufnr) → vim.lsp.get_clients({ bufnr = bufnr })")
    print("  vim.lsp.get_active_clients() → vim.lsp.get_clients()")
    print("  vim.api.nvim_buf_get_option(buf, 'opt') → vim.bo[buf].opt")
    print("  vim.lsp.buf.formatting() → vim.lsp.buf.format({ async = true })")
  end
  
  print("")
end

-- Check if running modern Neovim version
function M.version_check()
  local version = vim.version()
  print("=== Version Check ===")
  print(string.format("Neovim version: %d.%d.%d", version.major, version.minor, version.patch))
  
  if version.major == 0 then
    if version.minor >= 10 then
      print("✅ Modern Neovim 0.10+ - deprecated APIs removed")
    elseif version.minor >= 9 then
      print("⚠️  Neovim 0.9+ - some deprecated APIs available but warned")
    else
      print("❌ Older Neovim - consider upgrading")
    end
  end
  print("")
end

-- Quick plugin check
function M.plugin_check()
  print("=== Plugin Check ===")
  local lazy_ok, lazy = pcall(require, "lazy")
  if lazy_ok then
    local stats = lazy.stats()
    print(string.format("📦 Plugins: %d total, %d loaded", stats.count, stats.loaded))
    
    -- Check if we have too many loaded plugins
    if stats.loaded > 40 then
      print("⚠️  Many plugins loaded - consider more lazy loading")
    else
      print("✅ Good plugin loading strategy")
    end
  else
    print("❌ Lazy.nvim not found")
  end
  print("")
end

-- Main check function
function M.check_all()
  M.version_check()
  M.plugin_check()
  M.quick_check()
  
  print("=== Next Steps ===")
  print("1. If deprecated patterns found, update them manually")
  print("2. Run :checkhealth vim.deprecated for official check")
  print("3. Monitor startup for any warnings")
  print("4. Update plugins regularly with :Lazy update")
end

-- Create simple user command
vim.api.nvim_create_user_command('QuickDeprecationCheck', M.check_all, {
  desc = 'Quick and reliable deprecation check'
})

-- Simple keymap
vim.keymap.set('n', '<leader>cq', M.check_all, { desc = 'Quick deprecation check' })

return M