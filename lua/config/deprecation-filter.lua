-- Compatibility layer to reduce deprecation warnings from plugins
-- This patches deprecated functions to reduce noise in logs

local M = {}

-- Store original functions
local original_deprecate = vim.deprecate
local deprecation_counts = {}

-- Enhanced deprecate function with filtering
function M.setup_deprecation_filter()
  vim.deprecate = function(name, alternative, version, plugin, backtrace)
    -- Track deprecation counts
    deprecation_counts[name] = (deprecation_counts[name] or 0) + 1
    
    -- Filter out noisy deprecations from plugins we can't easily fix
    local noisy_plugins = {
      "telescope.nvim",
      "plenary.nvim", 
      "nvim-treesitter",
      "project.nvim",
      "nvim-spectre",
      "nvim-dap-ui",
      "diffview.nvim",
      "git-conflict.nvim",
      "neotest-jest",
      "nvim-colorizer.lua",
      "nvim-hlslens"
    }
    
    -- Only log if it's from our config or if it's a new deprecation
    local should_log = true
    local should_notify = true
    
    -- Reduce noise for known plugin issues
    if plugin then
      for _, noisy in ipairs(noisy_plugins) do
        if plugin:find(noisy) then
          should_notify = false
          -- Only log every 10th occurrence for noisy plugins
          if deprecation_counts[name] % 10 ~= 1 then
            should_log = false
          end
          break
        end
      end
    end
    
    -- Always call original for proper handling
    if original_deprecate then
      original_deprecate(name, alternative, version, plugin, backtrace)
    end
    
    -- Log to our file
    if should_log then
      local log_file = vim.fn.stdpath('data') .. '/deprecation.log'
      local timestamp = os.date('%Y-%m-%d %H:%M:%S')
      local plugin_info = plugin and (' (from ' .. plugin .. ')') or ''
      local count_info = deprecation_counts[name] > 1 and (' [count: ' .. deprecation_counts[name] .. ']') or ''
      
      local log_entry = string.format(
        '[%s] DEPRECATED: %s -> %s (since %s)%s%s\n',
        timestamp,
        name,
        alternative or 'no alternative provided',
        version or 'unknown',
        plugin_info,
        count_info
      )
      
      local file = io.open(log_file, 'a')
      if file then
        file:write(log_entry)
        file:close()
      end
    end
    
    -- Show notification only for user config issues
    if should_notify and (not plugin or plugin:match('^custom') or plugin:match('^config')) then
      vim.notify(
        string.format('DEPRECATED: %s -> %s', name, alternative or 'no alternative'),
        vim.log.levels.WARN,
        { title = 'Configuration Warning' }
      )
    end
  end
end

-- Function to show deprecation statistics
function M.show_deprecation_stats()
  print("=== Deprecation Statistics ===")
  
  local sorted_counts = {}
  for name, count in pairs(deprecation_counts) do
    table.insert(sorted_counts, {name = name, count = count})
  end
  
  table.sort(sorted_counts, function(a, b) return a.count > b.count end)
  
  if #sorted_counts == 0 then
    print("No deprecations logged yet.")
    return
  end
  
  print("Top deprecated functions (runtime session):")
  for i, item in ipairs(sorted_counts) do
    if i <= 10 then -- Show top 10
      print(string.format("  %d. %s (%d times)", i, item.name, item.count))
    end
  end
  
  print(string.format("\nTotal unique deprecations: %d", #sorted_counts))
  
  -- Show plugin summary
  print("\n=== Known Plugin Issues ===")
  print("• nvim-hlslens: Heavy vim.validate usage (search highlighting)")
  print("• telescope.nvim: vim.tbl_flatten, vim.validate in multiple places")
  print("• project.nvim: vim.lsp.buf_get_clients for LSP detection")
  print("• git-conflict.nvim: vim.highlight for syntax highlighting")
  print("• nvim-colorizer.lua: vim.tbl_flatten for color processing")
  print("• neotest-jest: vim.tbl_flatten for test utilities")
  
  print("\nUse :CheckPluginDeprecation for detailed plugin status")
  print("Use :UpdateAllPlugins to get latest plugin versions")
end

-- Create commands
vim.api.nvim_create_user_command('DeprecationStats', M.show_deprecation_stats, {
  desc = 'Show deprecation statistics'
})

-- Add keymap
vim.keymap.set('n', '<leader>cds', M.show_deprecation_stats, { desc = 'Deprecation stats' })

-- Setup the filter
M.setup_deprecation_filter()

return M