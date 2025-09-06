local M = {}

-- Check if yazi binary is available in PATH
function M.check_yazi_binary()
  local handle = io.popen("which yazi 2>/dev/null")
  if handle then
    local result = handle:read("*a")
    handle:close()
    return result and result ~= ""
  end
  return false
end

-- Check if ya CLI utility is available in PATH (required for Neovim integration)
function M.check_ya_binary()
  -- First try normal PATH
  local handle = io.popen("which ya 2>/dev/null")
  if handle then
    local result = handle:read("*a")
    handle:close()
    if result and result ~= "" then
      return true
    end
  end
  
  -- If not found, try cargo bin directory directly
  local cargo_ya = os.getenv("HOME") .. "/.cargo/bin/ya"
  local file = io.open(cargo_ya, "r")
  if file then
    file:close()
    -- Add cargo bin to PATH if ya exists there
    local current_path = os.getenv("PATH") or ""
    if not string.match(current_path, "%.cargo/bin") then
      vim.env.PATH = os.getenv("HOME") .. "/.cargo/bin:" .. current_path
    end
    return true
  end
  
  return false
end

-- Check if Yazi plugin is loaded
function M.check_yazi_plugin()
  local ok, yazi = pcall(require, 'yazi')
  return ok and yazi
end

-- Install instructions for yazi binary
function M.show_install_instructions()
  local install_msg = [[
Yazi binary not found! For Ubuntu 24.04, install using:

RECOMMENDED (fastest):
1. Using snap:
   sudo snap install yazi

2. Using cargo (if you have Rust):
   curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
   source ~/.cargo/env
   cargo install --locked yazi-fm yazi-cli

3. Download AppImage (no installation needed):
   wget https://github.com/sxyazi/yazi/releases/latest/download/yazi-x86_64.AppImage
   chmod +x yazi-x86_64.AppImage
   sudo mv yazi-x86_64.AppImage /usr/local/bin/yazi

4. Build from source (Ubuntu 24.04):
   sudo apt update
   sudo apt install -y build-essential rustc cargo
   cargo install --locked yazi-fm yazi-cli
   echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> ~/.bashrc

After installation, run: source ~/.bashrc && nvim
Then try <leader>e again.
]]
  
  vim.notify(install_msg, vim.log.levels.WARN, { title = "Yazi Installation - Ubuntu 24.04" })
end

-- Open Yazi using the plugin
function M.open_yazi(path)
  -- First check if yazi binary exists
  if not M.check_yazi_binary() then
    M.show_install_instructions()
    return
  end
  
  -- Check if ya CLI utility exists (required for integration)
  if not M.check_ya_binary() then
    vim.notify("Yazi found but 'ya' CLI utility missing. Install via: cargo install --locked yazi-cli", vim.log.levels.WARN)
    return
  end
  
  -- Then check if plugin is loaded
  local yazi = M.check_yazi_plugin()
  if not yazi then
    vim.notify("Yazi plugin not loaded. Try :Lazy load yazi.nvim", vim.log.levels.WARN)
    return
  end
  
  -- Use pcall to catch any errors
  local ok, err = pcall(function()
    if path == 'cwd' then
      yazi.yazi(nil, vim.fn.getcwd())
    else
      yazi.yazi()
    end
  end)
  
  if not ok then
    vim.notify("Error opening yazi: " .. tostring(err) .. "\nTry running :checkhealth yazi", vim.log.levels.ERROR)
  end
end

-- Setup function
function M.setup()
  -- Check binaries first
  if not M.check_yazi_binary() then
    vim.notify("Yazi binary not found in PATH. Use <leader>yi for installation instructions.", vim.log.levels.WARN, { title = "Yazi Setup" })
    return false
  end
  
  if not M.check_ya_binary() then
    vim.notify("Yazi found but 'ya' CLI utility missing. Install via: cargo install --locked yazi-cli", vim.log.levels.WARN, { title = "Yazi Setup" })
    return false
  end
  
  -- Then check plugin
  local yazi = M.check_yazi_plugin()
  if yazi then
    vim.notify("Yazi plugin and both binaries (yazi + ya) are ready! 🚀", vim.log.levels.INFO, { title = "Yazi Setup" })
    return true
  else
    vim.notify("Yazi binaries found, but plugin not loaded. Try :Lazy load yazi.nvim", vim.log.levels.WARN)
    return false
  end
end

return M
