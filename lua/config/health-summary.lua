-- Health check summary and fixes
local M = {}

function M.check_common_issues()
  print("=== Common Health Check Issues & Status ===")
  
  -- Check Neovim version
  local version = vim.version()
  print(string.format("Neovim version: %d.%d.%d", version.major, version.minor, version.patch))
  
  -- Check LuaSnip jsregexp
  local has_jsregexp = pcall(function()
    return require('luasnip.util.jsregexp')
  end)
  
  if has_jsregexp then
    print("✅ LuaSnip jsregexp: Available")
  else
    print("⚠️  LuaSnip jsregexp: Not available - install with :Lazy build LuaSnip")
  end
  
  -- Check Lua version (informational)
  print("📋 System Lua version: " .. _VERSION)
  print("📋 Note: Luarocks Lua version warning is normal if no plugins need luarocks")
  
  -- Check LSP servers
  local lsp_servers = {}
  for _, client in pairs(vim.lsp.get_clients()) do
    table.insert(lsp_servers, client.name)
  end
  
  if #lsp_servers > 0 then
    print("✅ LSP servers active: " .. table.concat(lsp_servers, ", "))
  else
    print("📋 No LSP servers currently active (normal if no files open)")
  end
  
  -- Check completion
  local has_cmp = pcall(require, 'cmp')
  print(has_cmp and "✅ nvim-cmp: Available" or "❌ nvim-cmp: Not available")
  
  -- Check telescope
  local has_telescope = pcall(require, 'telescope')
  print(has_telescope and "✅ Telescope: Available" or "❌ Telescope: Not available")
  
  print("")
  print("=== Next Steps ===")
  print("1. Run :Lazy build LuaSnip to install jsregexp if needed")
  print("2. Restart Neovim to apply changes")
  print("3. Run :checkhealth for detailed plugin status")
end

-- Create user command
vim.api.nvim_create_user_command('HealthSummary', M.check_common_issues, {
  desc = 'Show health check summary'
})

-- Add keymap
vim.keymap.set('n', '<leader>chs', M.check_common_issues, { desc = 'Health summary' })

return M