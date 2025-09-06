local km = vim.keymap.set

-- Clear highlights
km('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlights' })

-- Diagnostics
km('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
km("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Show LSP diagnostic" })

-- File manager (Yazi) keymaps with enhanced error handling
local yazi_setup_ok, yazi_setup = pcall(require, 'config.yazi-setup')
if not yazi_setup_ok then
  vim.notify("Yazi setup module not found", vim.log.levels.WARN)
  yazi_setup = {
    open_yazi = function() vim.notify("Yazi not configured", vim.log.levels.WARN) end,
    setup = function() vim.notify("Yazi not configured", vim.log.levels.WARN) end
  }
end

km('n', '<leader>e', function()
  yazi_setup.open_yazi()
end, { desc = 'Open file manager (Yazi)' })

km('n', '<C-n>', function()
  yazi_setup.open_yazi()
end, { desc = 'Open file manager (Yazi)' })

km('n', '<leader>E', function()
  yazi_setup.open_yazi('cwd')
end, { desc = 'Open Yazi in working directory' })

-- Add a keymap to check Yazi plugin status
km('n', '<leader>yi', function()
  local yazi_setup = require('config.yazi-setup')
  if not yazi_setup.check_yazi_binary() then
    yazi_setup.show_install_instructions()
  else
    yazi_setup.setup()
  end
end, { desc = 'Check Yazi installation and show setup instructions' })

-- Tabs
km('n', '<leader>tn', ':tabnext<CR>', { desc = 'Next Tab' })
km('n', '<leader>tp', ':tabprevious<CR>', { desc = 'Previous Tab' })

-- Move lines
km('n', '<A-j>', ':m .+1<CR>==', { desc = 'Move line down' })
km('n', '<A-k>', ':m .-2<CR>==', { desc = 'Move line up' })
km('v', '<A-j>', ":m '>+1<CR>gv=gv", { desc = 'Move selection down' })
km('v', '<A-k>', ":m '<-2<CR>gv=gv", { desc = 'Move selection up' })

-- Move between buffers
km('n', '<S-l>', ':bnext<CR>', { desc = 'Next buffer' })
km('n', '<S-h>', ':bprevious<CR>', { desc = 'Previous buffer' })
km('n', '<leader>bd', ':bdelete<CR>', { desc = 'Delete current buffer' })
km('n', '<leader>bl', ':ls<CR>', { desc = 'list all buffers' })

-- Window navigation
km('n', '<C-h>', '<C-w><C-h>', { desc = 'Left window' })
km('n', '<C-l>', '<C-w><C-l>', { desc = 'Right window' })
km('n', '<C-j>', '<C-w><C-j>', { desc = 'Lower window' })
km('n', '<C-k>', '<C-w><C-k>', { desc = 'Upper window' })

-- Terminal

-- Exit terminal mode (alternative binding)
km('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
-- Note: <leader>t for floating terminal is configured in lazy.lua FTerm plugin

-- Additional Git keymaps (gitsigns keymaps are in lazygit.lua)
km('n', '<leader>gl', '<cmd>Git log --oneline<CR>', { desc = 'Git log' })
km('n', '<leader>gs', '<cmd>Git status<CR>', { desc = 'Git status' })
km('n', '<leader>gp', '<cmd>Git push<CR>', { desc = 'Git push' })
km('n', '<leader>gP', '<cmd>Git pull<CR>', { desc = 'Git pull' })
km('n', '<leader>gf', '<cmd>Git fetch<CR>', { desc = 'Git fetch' })
km('n', '<leader>ga', '<cmd>Git add %<CR>', { desc = 'Git add current file' })
km('n', '<leader>gA', '<cmd>Git add .<CR>', { desc = 'Git add all' })
km('n', '<leader>gco', '<cmd>Git checkout ', { desc = 'Git checkout' })
km('n', '<leader>gcb', '<cmd>Git checkout -b ', { desc = 'Git checkout new branch' })
km('n', '<leader>gm', '<cmd>Git merge ', { desc = 'Git merge' })

-- Quick git commands
km('n', '<leader>gq', function()
  vim.ui.input({ prompt = 'Quick commit message: ' }, function(input)
    if input and input ~= '' then
      vim.cmd('Git add .')
      vim.cmd('Git commit -m "' .. input .. '"')
    end
  end)
end, { desc = 'Quick git commit' })

-- Telescope
local telescope_ok, builtin = pcall(require, 'telescope.builtin')
if telescope_ok then
  km('n', '<leader>ff', builtin.find_files, { desc = "Find files" })
  km('n', '<leader>fg', builtin.live_grep,  { desc = "Live grep project" })
  km('n', '<leader>fb', builtin.buffers,    { desc = "Find buffers" })
  km('n', '<leader>fh', builtin.help_tags,  { desc = "Find help" })
else
  km('n', '<leader>ff', function() vim.notify("Telescope not available", vim.log.levels.WARN) end, { desc = "Find files (Telescope not loaded)" })
  km('n', '<leader>fg', function() vim.notify("Telescope not available", vim.log.levels.WARN) end, { desc = "Live grep (Telescope not loaded)" })
  km('n', '<leader>fb', function() vim.notify("Telescope not available", vim.log.levels.WARN) end, { desc = "Find buffers (Telescope not loaded)" })
  km('n', '<leader>fh', function() vim.notify("Telescope not available", vim.log.levels.WARN) end, { desc = "Find help (Telescope not loaded)" })
end

-- Formatter
km('n', '<leader>cf', function()
  if vim.bo.filetype == 'lua' then
    vim.cmd('!stylua %')
  else
    vim.lsp.buf.format({ async = true })
  end
end, { desc = 'Format current file' })

-- Copy full file path to clipboard
-- Usage: <leader>y in normal mode
--
km('n', '<leader>y', function()
  local file_path = vim.fn.expand('%:p')
  vim.fn.setreg('+', file_path)
  print('Copied to clipboard: ' .. file_path)
end, { desc = 'Copy full file path to clipboard' })

-- UI and Theme toggles
km('n', '<leader>tt', '<cmd>TransparencyToggle<CR>', { desc = '[T]oggle [T]ransparency' })
km('n', '<leader>tc', function()
  -- Cycle through different colorschemes (only those that are available)
  local colorschemes = {
    'github_dark_default',
    'github_dark_dimmed',
    'github_dark_high_contrast',
    'github_light_default',
    'github_light_high_contrast',
  }
  local current = vim.g.colors_name or 'github_dark_default'
  local current_index = 1
  
  for i, scheme in ipairs(colorschemes) do
    if scheme == current then
      current_index = i
      break
    end
  end
  
  local next_index = (current_index % #colorschemes) + 1
  local next_scheme = colorschemes[next_index]
  
  -- Check if the colorscheme exists before trying to apply it
  local ok, _ = pcall(vim.cmd, 'colorscheme ' .. next_scheme)
  if ok then
    print('Switched to colorscheme: ' .. next_scheme)
  else
    print('Colorscheme not found: ' .. next_scheme)
    -- Fallback to default
    vim.cmd('colorscheme github_dark_default')
    print('Switched to fallback colorscheme: github_dark_default')
  end
end, { desc = '[T]oggle [C]olorscheme' })

-- Enable additional themes (TokyoNight and Catppuccin)
km('n', '<leader>tE', function()
  vim.ui.select(
    { 'TokyoNight', 'Catppuccin', 'Both' },
    { prompt = 'Enable additional themes:' },
    function(choice)
      if choice == 'TokyoNight' or choice == 'Both' then
        require('lazy').load({ plugins = { 'tokyonight.nvim' } })
        print('TokyoNight theme enabled!')
      end
      if choice == 'Catppuccin' or choice == 'Both' then
        require('lazy').load({ plugins = { 'catppuccin' } })
        print('Catppuccin theme enabled!')
      end
      if choice then
        print('Use <leader>tc to cycle through available themes')
      end
    end
  )
end, { desc = '[T]heme [E]nable additional themes' })

-- Enhanced colorscheme cycling that includes enabled themes
km('n', '<leader>tC', function()
  -- Get all available colorschemes dynamically
  local all_schemes = vim.fn.getcompletion('', 'color')
  local preferred_schemes = {
    'github_dark_default',
    'github_dark_dimmed', 
    'github_dark_high_contrast',
    'github_light_default',
    'tokyonight-storm',
    'tokyonight-moon',
    'tokyonight-night',
    'catppuccin-mocha',
    'catppuccin-macchiato',
    'catppuccin-frappe',
    'catppuccin-latte',
  }
  
  -- Filter to only include available schemes
  local available_schemes = {}
  for _, scheme in ipairs(preferred_schemes) do
    for _, available in ipairs(all_schemes) do
      if available == scheme then
        table.insert(available_schemes, scheme)
        break
      end
    end
  end
  
  if #available_schemes == 0 then
    available_schemes = { 'github_dark_default' }
  end
  
  local current = vim.g.colors_name or 'github_dark_default'
  local current_index = 1
  
  for i, scheme in ipairs(available_schemes) do
    if scheme == current then
      current_index = i
      break
    end
  end
  
  local next_index = (current_index % #available_schemes) + 1
  local next_scheme = available_schemes[next_index]
  
  vim.cmd('colorscheme ' .. next_scheme)
  print('Switched to colorscheme: ' .. next_scheme .. ' (' .. current_index .. '/' .. #available_schemes .. ')')
end, { desc = '[T]heme [C]ycle (all available)' })

-- Window and buffer management improvements
km('n', '<leader>w-', '<cmd>split<CR>', { desc = 'Split window horizontally' })
km('n', '<leader>w|', '<cmd>vsplit<CR>', { desc = 'Split window vertically' })
km('n', '<leader>w=', '<C-w>=', { desc = 'Equalize window sizes' })
km('n', '<leader>wx', '<cmd>close<CR>', { desc = 'Close current window' })
km('n', '<leader>wm', '<cmd>only<CR>', { desc = 'Maximize current window' })

-- Buffer management (enhanced)
km('n', '<leader>ba', '<cmd>%bdelete|edit#|bdelete#<CR>', { desc = 'Close all buffers except current' })
km('n', '<leader>bx', '<cmd>bdelete!<CR>', { desc = 'Force close current buffer' })
km('n', '<leader>bn', '<cmd>enew<CR>', { desc = 'New buffer' })

-- Quick resize windows
km('n', '<C-Up>', '<cmd>resize +2<CR>', { desc = 'Increase window height' })
km('n', '<C-Down>', '<cmd>resize -2<CR>', { desc = 'Decrease window height' })
km('n', '<C-Left>', '<cmd>vertical resize -2<CR>', { desc = 'Decrease window width' })
km('n', '<C-Right>', '<cmd>vertical resize +2<CR>', { desc = 'Increase window width' })

-- Visual mode improvements
km('v', '<', '<gv', { desc = 'Dedent and reselect' })
km('v', '>', '>gv', { desc = 'Indent and reselect' })

-- Search and replace
km('n', '<leader>sr', ':%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>', { desc = 'Search and replace word under cursor' })
km('v', '<leader>sr', '"hy:%s/<C-r>h//gc<left><left><left>', { desc = 'Search and replace selection' })

-- Better paste in visual mode (doesn't replace register)
km('v', 'p', '"_dP', { desc = 'Paste without replacing register' })

-- Spell checking toggle
km('n', '<leader>ts', '<cmd>set spell!<CR>', { desc = '[T]oggle [S]pell check' })

-- Quick save and quit
km('n', '<leader>w', '<cmd>w<CR>', { desc = 'Save file' })
km('n', '<leader>W', '<cmd>wa<CR>', { desc = 'Save all files' })
km('n', '<leader>Q', '<cmd>qa<CR>', { desc = 'Quit all' })

-- Center screen after common navigation
km('n', 'n', 'nzzzv', { desc = 'Next search result (centered)' })
km('n', 'N', 'Nzzzv', { desc = 'Previous search result (centered)' })
km('n', '<C-d>', '<C-d>zz', { desc = 'Half page down (centered)' })
km('n', '<C-u>', '<C-u>zz', { desc = 'Half page up (centered)' })

-- Toggle line wrapping
km('n', '<leader>tw', '<cmd>set wrap!<CR>', { desc = '[T]oggle line [W]rap' })

-- Node.js/TypeScript specific keymaps
km('n', '<leader>nr', '<cmd>!npm run<CR>', { desc = '[N]pm [R]un script' })
km('n', '<leader>ni', '<cmd>!npm install<CR>', { desc = '[N]pm [I]nstall' })
km('n', '<leader>nt', '<cmd>!npm test<CR>', { desc = '[N]pm [T]est' })
km('n', '<leader>nb', '<cmd>!npm run build<CR>', { desc = '[N]pm [B]uild' })
km('n', '<leader>nd', '<cmd>!npm run dev<CR>', { desc = '[N]pm [D]ev' })
km('n', '<leader>ns', '<cmd>!npm start<CR>', { desc = '[N]pm [S]tart' })

-- Yarn alternatives
km('n', '<leader>yr', '<cmd>!yarn run<CR>', { desc = '[Y]arn [R]un script' })
km('n', '<leader>yi', '<cmd>!yarn install<CR>', { desc = '[Y]arn [I]nstall' })
km('n', '<leader>yt', '<cmd>!yarn test<CR>', { desc = '[Y]arn [T]est' })
km('n', '<leader>yb', '<cmd>!yarn build<CR>', { desc = '[Y]arn [B]uild' })
km('n', '<leader>yd', '<cmd>!yarn dev<CR>', { desc = '[Y]arn [D]ev' })
km('n', '<leader>ys', '<cmd>!yarn start<CR>', { desc = '[Y]arn [S]tart' })

-- LSP diagnostic navigation
km('n', '[d', vim.diagnostic.goto_prev, { desc = 'Previous diagnostic' })
km('n', ']d', vim.diagnostic.goto_next, { desc = 'Next diagnostic' })
km('n', '[e', function()
  vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
end, { desc = 'Previous error' })
km('n', ']e', function()
  vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
end, { desc = 'Next error' })

-- Highlight yanked text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})


