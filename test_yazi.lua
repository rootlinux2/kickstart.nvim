-- Test script for yazi configuration
print("=== Testing Yazi Configuration ===")

-- Add cargo to PATH
local home = os.getenv("HOME")
if home then
  local cargo_bin = home .. "/.cargo/bin"
  local current_path = os.getenv("PATH") or ""
  if not string.match(current_path, "%.cargo/bin") then
    os.execute("export PATH=" .. cargo_bin .. ":$PATH")
  end
end

-- Test yazi setup
local ok, yazi_setup = pcall(require, 'config.yazi-setup')
if not ok then
  print("ERROR: Could not load yazi-setup: " .. tostring(yazi_setup))
  return
end

print("1. Testing yazi binary...")
local yazi_ok = yazi_setup.check_yazi_binary()
print("   Yazi binary available: " .. tostring(yazi_ok))

print("2. Testing ya binary...")
local ya_ok = yazi_setup.check_ya_binary()
print("   Ya binary available: " .. tostring(ya_ok))

print("3. Testing yazi plugin...")
local plugin_ok = yazi_setup.check_yazi_plugin()
print("   Yazi plugin loaded: " .. tostring(plugin_ok))

print("4. Running setup...")
local setup_result = yazi_setup.setup()
print("   Setup result: " .. tostring(setup_result))

print("=== Test Complete ===")
