local km = vim.keymap.set

-- Clear highlights
km('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlights' })

-- Diagnostics
km('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

km('n', '<leader>cd', vim.diagnostic.open_float, { desc = 'Show LSP diagnostic' })

-- Tabs
km('n', '<leader>tn', ':tabnext<CR>', { desc = 'Next Tab' })
km('n', '<leader>tp', ':tabprevious<CR>', { desc = 'Previous Tab' })
km('n', '<leader>tc', ':tabclose<CR>', { desc = 'Close Tab' })
km('n', '<leader>to', ':tabonly<CR>', { desc = 'Close all other tabs' })
km('n', '<leader>tt', ':tabnew<CR>', { desc = 'New Tab' })

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

-- Terminal (built-in only)
-- Exit terminal mode (alternative binding)
km('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

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
      vim.cmd 'Git add .'
      vim.cmd('Git commit -m "' .. input .. '"')
    end
  end)
end, { desc = 'Quick git commit' })

-- Telescope
local telescope_ok, builtin = pcall(require, 'telescope.builtin')
if telescope_ok then
  km('n', '<leader>ff', builtin.find_files, { desc = 'Find files' })
  km('n', '<leader>fg', builtin.live_grep, { desc = 'Live grep project' })
  km('n', '<leader>fb', builtin.buffers, { desc = 'Find buffers' })
  km('n', '<leader>fh', builtin.help_tags, { desc = 'Find help' })
else
  km('n', '<leader>ff', function()
    vim.notify('Telescope not available', vim.log.levels.WARN)
  end, { desc = 'Find files (Telescope not loaded)' })
  km('n', '<leader>fg', function()
    vim.notify('Telescope not available', vim.log.levels.WARN)
  end, { desc = 'Live grep (Telescope not loaded)' })
  km('n', '<leader>fb', function()
    vim.notify('Telescope not available', vim.log.levels.WARN)
  end, { desc = 'Find buffers (Telescope not loaded)' })
  km('n', '<leader>fh', function()
    vim.notify('Telescope not available', vim.log.levels.WARN)
  end, { desc = 'Find help (Telescope not loaded)' })
end

-- Formatter
km('n', '<leader>cf', function()
  if vim.bo.filetype == 'lua' then
    vim.cmd '!stylua %'
  else
    vim.lsp.buf.format { async = true }
  end
end, { desc = 'Format current file' })

-- Copy full file path to clipboard
-- Usage: <leader>y in normal mode
--
km('n', '<leader>y', function()
  local file_path = vim.fn.expand '%:p'
  vim.fn.setreg('+', file_path)
  print('Copied to clipboard: ' .. file_path)
end, { desc = 'Copy full file path to clipboard' })

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
  vim.diagnostic.goto_prev { severity = vim.diagnostic.severity.ERROR }
end, { desc = 'Previous error' })
km('n', ']e', function()
  vim.diagnostic.goto_next { severity = vim.diagnostic.severity.ERROR }
end, { desc = 'Next error' })

-- Optional: auto-import for JS/TS (if using nvim-lspconfig with tsserver)

km('n', '<leader>ai', function()
  local params = vim.lsp.util.make_range_params()
  params.context = { only = { 'source.addMissingImports.ts', 'source.addMissingImports.js' } }
  local results = vim.lsp.buf_request_sync(0, 'textDocument/codeAction', params, 1000)
  for _, res in pairs(results or {}) do
    for _, r in pairs(res.result or {}) do
      if r.edit then
        vim.lsp.util.apply_workspace_edit(r.edit, 'utf-16')
      else
        vim.lsp.buf.execute_command(r.command)
      end
    end
  end
end, { desc = 'Auto-import missing JS/TS imports' })

-- Highlight yanked text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

km('n', '<leader>e', ':Neotree toggle<CR>', { desc = 'Toggle Neo-tree' })
