-- Plugin deprecation fixes and update guide
local M = {}

-- Function to check if plugins need updates
function M.check_plugin_updates()
  print("=== Plugin Deprecation Status ===")
  
  local deprecated_plugins = {
    {
      name = "project.nvim", 
      issue = "Uses vim.lsp.buf_get_clients()",
      status = "Known issue - waiting for plugin update",
      action = "Monitor plugin updates"
    },
    {
      name = "telescope.nvim",
      issue = "Uses vim.tbl_flatten, vim.validate",
      status = "Actively maintained - should update soon",
      action = "Update regularly with :Lazy update"
    },
    {
      name = "git-conflict.nvim",
      issue = "Uses vim.highlight",
      status = "Needs update to use vim.hl",
      action = "Check for updates or fork if needed"
    },
    {
      name = "neotest-jest",
      issue = "Uses vim.tbl_flatten",
      status = "Testing plugin - may need update",
      action = "Monitor updates for testing suite"
    },
    {
      name = "nvim-colorizer.lua",
      issue = "Uses vim.tbl_flatten",
      status = "Color plugin - check for updates",
      action = "Update or find alternative"
    },
    {
      name = "nvim-hlslens",
      issue = "Uses vim.validate (old API)",
      status = "Search highlighting - needs update",
      action = "Monitor for vim.validate API fix"
    },
    {
      name = "plenary.nvim",
      issue = "Uses vim.tbl_flatten and vim.validate",
      status = "Core dependency - waiting for update",
      action = "Monitor updates - affects many plugins"
    },
    {
      name = "nvim-treesitter",
      issue = "Uses vim.tbl_flatten in compatibility layer",
      status = "Expected - compatibility for older Neovim",
      action = "Normal - no action needed"
    },
    {
      name = "nvim-spectre",
      issue = "Uses vim.tbl_flatten",
      status = "Has modern fallback",
      action = "Should resolve automatically"
    }
  }
  
  for _, plugin in ipairs(deprecated_plugins) do
    print(string.format("📦 %s:", plugin.name))
    print(string.format("   Issue: %s", plugin.issue))
    print(string.format("   Status: %s", plugin.status))
    print(string.format("   Action: %s", plugin.action))
    print("")
  end
  
  print("=== Recommendations ===")
  print("1. Run :Lazy update regularly to get latest plugin versions")
  print("2. Most warnings are from plugins and will resolve with updates")
  print("3. The deprecation filter reduces noise while keeping important warnings")
  print("4. Check :DeprecationStats to see which functions are called most")
end

-- Function to update all plugins
function M.update_all_plugins()
  print("Updating all plugins...")
  require('lazy').update({wait = true})
  print("Plugin update complete!")
end

-- Function to clean and rebuild problematic plugins
function M.rebuild_plugins()
  print("Rebuilding plugins with native dependencies...")
  
  local plugins_to_rebuild = {
    'telescope-fzf-native.nvim',
    'LuaSnip'
  }
  
  for _, plugin in ipairs(plugins_to_rebuild) do
    local ok = pcall(function()
      require('lazy').build({plugins = {plugin}, wait = true})
    end)
    if ok then
      print("✅ Rebuilt " .. plugin)
    else
      print("⚠️  Could not rebuild " .. plugin)
    end
  end
end

-- Create user commands
vim.api.nvim_create_user_command('CheckPluginDeprecation', M.check_plugin_updates, {
  desc = 'Check plugin deprecation status'
})

vim.api.nvim_create_user_command('UpdateAllPlugins', M.update_all_plugins, {
  desc = 'Update all plugins'
})

vim.api.nvim_create_user_command('RebuildPlugins', M.rebuild_plugins, {
  desc = 'Rebuild plugins with native dependencies'
})

-- Add keymaps
vim.keymap.set('n', '<leader>cpu', M.check_plugin_updates, { desc = 'Check plugin updates' })
vim.keymap.set('n', '<leader>cuu', M.update_all_plugins, { desc = 'Update all plugins' })
vim.keymap.set('n', '<leader>crp', M.rebuild_plugins, { desc = 'Rebuild plugins' })

return M