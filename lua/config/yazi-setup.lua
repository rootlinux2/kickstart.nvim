local M = {}

-- Check if Yazi plugin is loaded
function M.check_yazi_plugin()
  local ok, yazi = pcall(require, 'yazi')
  return ok and yazi
end

-- Open Yazi using the plugin
function M.open_yazi(path)
  local yazi = M.check_yazi_plugin()
  if not yazi then
    vim.notify("Yazi plugin not loaded. Try :Lazy load yazi.nvim", vim.log.levels.WARN)
    return
  end
  
  if path == 'cwd' then
    yazi.yazi(nil, vim.fn.getcwd())
  else
    yazi.yazi()
  end
end

-- Setup function
function M.setup()
  local yazi = M.check_yazi_plugin()
  if yazi then
    vim.notify("Yazi plugin loaded successfully!", vim.log.levels.INFO, { title = "Yazi Setup" })
    return true
  else
    vim.notify("Yazi plugin not found. Make sure yazi.nvim is installed via Lazy.", vim.log.levels.WARN)
    return false
  end
end

return M
After installation, restart Neovim or reload your config.
]]
  
  vim.notify(install_msg, vim.log.levels.WARN, { title = "Yazi Setup" })
end

-- Setup Yazi integration
function M.setup()
  if not M.check_yazi() then
    M.install_instructions()
    return false
  end
  
  -- Yazi is available, set up the integration
  vim.notify("Yazi found and ready to use!", vim.log.levels.INFO, { title = "Yazi Setup" })
  return true
end

-- Enhanced Yazi command with error handling
function M.open_yazi(path)
  if not M.check_yazi() then
    M.install_instructions()
    return
  end
  
  local cmd = path and ("Yazi " .. path) or "Yazi"
  vim.cmd(cmd)
end

return M
