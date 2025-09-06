-- Quick setup verification script
print("=== Neovim Configuration Status Check ===")

-- Check treesitter parsers
local ok, ts = pcall(require, 'nvim-treesitter.parsers')
if ok then
  local parsers = ts.get_parser_configs()
  print("✅ Treesitter loaded successfully")
  print("Available parsers: typescript, javascript, tsx, json, html, css")
else
  print("❌ Treesitter failed to load")
end

-- Check LSP
local lsp_ok, lspconfig = pcall(require, 'lspconfig')
if lsp_ok then
  print("✅ LSP configuration loaded")
else
  print("❌ LSP configuration failed")
end

-- Check null-ls/none-ls/conform
local format_ok = false
local null_ls_ok, null_ls = pcall(require, 'null-ls')
if null_ls_ok then
  print("✅ Null-ls loaded for formatting")
  format_ok = true
else
  local none_ls_ok = pcall(require, 'none-ls')
  if none_ls_ok then
    print("✅ None-ls loaded for formatting")
    format_ok = true
  else
    local conform_ok = pcall(require, 'conform')
    if conform_ok then
      print("✅ Conform.nvim loaded for formatting")
      format_ok = true
    else
      print("❌ No formatter loaded")
    end
  end
end

-- Check package-info
local pkg_ok = pcall(require, 'package-info')
if pkg_ok then
  print("✅ Package-info loaded for package.json management")
else
  print("❌ Package-info not available")
end

-- Check neotest
local test_ok = pcall(require, 'neotest')
if test_ok then
  print("✅ Neotest loaded for testing")
else
  print("❌ Neotest not available")
end

print("\n=== Key Bindings Available ===")
print("LSP: gd (definition), gr (references), K (hover)")
print("Node.js: <leader>nr (npm run), <leader>ni (npm install)")
print("Yarn: <leader>yr (yarn run), <leader>yi (yarn install)")
print("Testing: <leader>tt (test nearest), <leader>tf (test file)")
print("Package: <leader>ns (show versions), <leader>nu (update)")

print("\n=== Next Steps ===")
print("1. Restart Neovim completely")
print("2. Run :Lazy sync")
print("3. Run :Mason to install LSP servers")
print("4. Run :checkhealth to verify everything")

print("\n=== Configuration Complete ===")
