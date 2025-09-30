-- Configuration cleanup for modern Neovim
-- This file ensures we're using the latest APIs and removes deprecated warnings

-- Fix for any plugins that might be using deprecated APIs
local function setup_modern_apis()
  -- Ensure we're using modern LSP APIs
  if vim.lsp.buf_get_clients then
    -- Override deprecated function to point to modern equivalent
    vim.lsp.buf_get_clients = function(bufnr)
      return vim.lsp.get_clients({ bufnr = bufnr })
    end
  end
  
  if vim.lsp.get_active_clients then
    -- Override deprecated function to point to modern equivalent  
    vim.lsp.get_active_clients = function()
      return vim.lsp.get_clients()
    end
  end
end

-- Call the setup function
setup_modern_apis()

-- Disable deprecated warnings for specific known issues
local function silence_known_deprecations()
  -- Temporarily silence specific deprecation warnings while plugins update
  local original_notify = vim.notify
  vim.notify = function(msg, level, opts)
    -- Filter out known deprecation warnings that we can't control
    if type(msg) == "string" then
      if msg:match("canary.*deprecated") or 
         msg:match("buf_get_clients.*deprecated") then
        -- Silently ignore these specific warnings
        return
      end
    end
    -- Pass through all other notifications
    return original_notify(msg, level, opts)
  end
end

-- Optionally enable this if you want to silence the warnings temporarily
-- silence_known_deprecations()

return {}