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

-- Toggle transparency
km('n', '<leader>tT', function()
  local tokyonight = require("tokyonight")
  local config = require("tokyonight.config")
  
  -- Toggle transparency
  config.options.transparent = not config.options.transparent
  tokyonight.load()
end, { desc = '[T]oggle [T]ransparency' })

-- Folding keymaps (za, zo, zc should work by default, but adding convenient alternatives)
km('n', '<leader>zo', 'zo', { desc = 'Fold [O]pen' })
km('n', '<leader>zc', 'zc', { desc = 'Fold [C]lose' })
km('n', '<leader>za', 'za', { desc = 'Fold Toggle [A]ll' })
km('n', '<leader>zO', 'zO', { desc = 'Fold [O]pen all nested' })
km('n', '<leader>zC', 'zC', { desc = 'Fold [C]lose all nested' })
km('n', '<leader>zm', 'zM', { desc = 'Fold [M]ore - Close all folds' })
km('n', '<leader>zr', 'zR', { desc = 'Fold [R]educe - Open all folds' })
km('n', '<leader>zj', 'zj', { desc = 'Next fold' })
km('n', '<leader>zk', 'zk', { desc = 'Previous fold' })

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

-- Neo-tree
km('n', '<leader>e', function()
  -- Ensure Neo-tree is loaded before calling the command
  pcall(require, 'neo-tree')
  vim.cmd('Neotree toggle')
end, { desc = 'Toggle Neo-tree' })
km('n', '\\', function()
  pcall(require, 'neo-tree')
  vim.cmd('Neotree reveal')
end, { desc = 'NeoTree reveal' })

-- Copilot (Insert mode)
km('i', '<C-J>', 'copilot#Accept("\\<CR>")', { 
  expr = true, 
  replace_keycodes = false, 
  desc = 'Accept Copilot suggestion' 
})
km('i', '<C-H>', '<Plug>(copilot-dismiss)', { 
  replace_keycodes = false, 
  desc = 'Dismiss Copilot suggestion' 
})
km('i', '<C-L>', '<Plug>(copilot-next)', { 
  replace_keycodes = false, 
  desc = 'Next Copilot suggestion' 
})
km('i', '<C-K>', '<Plug>(copilot-previous)', { 
  replace_keycodes = false, 
  desc = 'Previous Copilot suggestion' 
})
km('i', '<C-\\>', '<Plug>(copilot-suggest)', { 
  replace_keycodes = false, 
  desc = 'Trigger Copilot suggestion' 
})

-- Copilot (Normal mode)
km('n', '<leader>cs', '<cmd>Copilot status<CR>', { desc = 'Copilot status' })
km('n', '<leader>cp', '<cmd>Copilot panel<CR>', { desc = 'Copilot panel' })

-- Copilot Chat
km({ 'n', 'v' }, '<leader>cc', function()
  require('CopilotChat').open()
end, { desc = 'Open Copilot Chat' })

km({ 'n', 'v' }, '<leader>ccq', function()
  local input = vim.fn.input 'Quick Chat: '
  if vim.trim(input) ~= '' then
    require('CopilotChat').ask(input, { selection = require('CopilotChat.select').buffer })
  end
end, { desc = 'Quick chat' })

km('v', '<leader>cce', function()
  require('CopilotChat').ask('Explain how this code works.', { selection = require('CopilotChat.select').visual })
end, { desc = 'Explain code' })

km('v', '<leader>ccv', function()
  require('CopilotChat').ask('Review this code and suggest improvements.', { selection = require('CopilotChat.select').visual })
end, { desc = 'Review code' })

km('v', '<leader>ccf', function()
  require('CopilotChat').ask('Fix this code.', { selection = require('CopilotChat.select').visual })
end, { desc = 'Fix code' })

km('v', '<leader>cco', function()
  require('CopilotChat').ask('Optimize this code.', { selection = require('CopilotChat.select').visual })
end, { desc = 'Optimize code' })

km('v', '<leader>ccd', function()
  require('CopilotChat').ask('Add documentation for this code.', { selection = require('CopilotChat.select').visual })
end, { desc = 'Document code' })

km('v', '<leader>cct', function()
  require('CopilotChat').ask('Generate tests for this code.', { selection = require('CopilotChat.select').visual })
end, { desc = 'Generate tests' })

km('n', '<leader>ccx', function()
  require('CopilotChat').close()
end, { desc = 'Close Copilot Chat' })

km('n', '<leader>ccr', function()
  require('CopilotChat').reset()
end, { desc = 'Reset Copilot Chat' })

-- Linting
km('n', '<leader>l', function()
  local ok, err = pcall(function()
    require('lint').try_lint()
  end)
  if not ok then
    vim.notify('Linting error: ' .. tostring(err), vim.log.levels.ERROR)
  else
    vim.notify('Linting completed', vim.log.levels.INFO)
  end
end, { desc = 'Trigger linting for current file' })

-- Debug (DAP)
-- Function keys for debugging
km('n', '<F5>', function() require('dap').continue() end, { desc = 'Debug: Start/Continue' })
km('n', '<F1>', function() require('dap').step_into() end, { desc = 'Debug: Step Into' })
km('n', '<F2>', function() require('dap').step_over() end, { desc = 'Debug: Step Over' })
km('n', '<F3>', function() require('dap').step_out() end, { desc = 'Debug: Step Out' })
km('n', '<F7>', function() require('dapui').toggle() end, { desc = 'Debug: See last session result' })

-- Leader key debug mappings
km('n', '<leader>b', function() require('dap').toggle_breakpoint() end, { desc = 'Debug: Toggle Breakpoint' })
km('n', '<leader>B', function() 
  require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ') 
end, { desc = 'Debug: Set Breakpoint' })
km('n', '<leader>db', function() require('dap').toggle_breakpoint() end, { desc = '[D]ebug: Toggle [B]reakpoint' })
km('n', '<leader>dB', function()
  require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
end, { desc = '[D]ebug: Set conditional breakpoint' })
km('n', '<leader>dc', function() require('dap').continue() end, { desc = '[D]ebug: [C]ontinue' })
km('n', '<leader>dC', function() require('dap').run_to_cursor() end, { desc = '[D]ebug: Run to [C]ursor' })
km('n', '<leader>dg', function() require('dap').goto_() end, { desc = '[D]ebug: [G]o to line (no execute)' })
km('n', '<leader>di', function() require('dap').step_into() end, { desc = '[D]ebug: Step [I]nto' })
km('n', '<leader>dj', function() require('dap').down() end, { desc = '[D]ebug: Down' })
km('n', '<leader>dk', function() require('dap').up() end, { desc = '[D]ebug: Up' })
km('n', '<leader>dl', function() require('dap').run_last() end, { desc = '[D]ebug: Run [L]ast' })
km('n', '<leader>do', function() require('dap').step_out() end, { desc = '[D]ebug: Step [O]ut' })
km('n', '<leader>dO', function() require('dap').step_over() end, { desc = '[D]ebug: Step [O]ver' })
km('n', '<leader>dp', function() require('dap').pause() end, { desc = '[D]ebug: [P]ause' })
km('n', '<leader>dr', function() require('dap').repl.open() end, { desc = '[D]ebug: Open [R]EPL' })
km('n', '<leader>ds', function() require('dap').session() end, { desc = '[D]ebug: [S]ession' })
km('n', '<leader>dt', function() require('dap').terminate() end, { desc = '[D]ebug: [T]erminate' })
km('n', '<leader>du', function() require('dapui').toggle() end, { desc = '[D]ebug: Toggle [U]I' })
km('n', '<leader>dw', function()
  require('dap.ui.widgets').hover()
end, { desc = '[D]ebug: [W]idgets' })
km({ 'n', 'v' }, '<leader>dh', function()
  require('dap.ui.widgets').hover()
end, { desc = '[D]ebug: [H]over Variables' })
km({ 'n', 'v' }, '<leader>dW', function()
  require('dap.ui.widgets').preview()
end, { desc = '[D]ebug: [W]idget preview' })

-- Todo Comments
km('n', ']t', function() require('todo-comments').jump_next() end, { desc = 'Next todo comment' })
km('n', '[t', function() require('todo-comments').jump_prev() end, { desc = 'Previous todo comment' })
km('n', '<leader>xt', '<cmd>TodoTrouble<cr>', { desc = 'Todo (Trouble)' })
km('n', '<leader>xT', '<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>', { desc = 'Todo/Fix/Fixme (Trouble)' })
km('n', '<leader>st', '<cmd>TodoTelescope<cr>', { desc = 'Todo' })
km('n', '<leader>sT', '<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>', { desc = 'Todo/Fix/Fixme' })

-- Additional Telescope keymaps (from lazy.lua)
km('n', '<leader>sh', function() require('telescope.builtin').help_tags() end, { desc = '[S]earch [H]elp' })
km('n', '<leader>sf', function() require('telescope.builtin').find_files() end, { desc = '[S]earch [F]iles' })
km('n', '<leader>ss', function() require('telescope.builtin').builtin() end, { desc = '[S]earch [S]elect Telescope' })
