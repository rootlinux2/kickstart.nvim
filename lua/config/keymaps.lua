local km = vim.keymap.set

-- Clear highlights
km('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlights' })

-- Diagnostics
km('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
km("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show LSP error" })

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

-- Exit terminal mode
km('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
-- Open floating terminal
km('n', '<leader>t', ':lua require("FTerm").toggle()<CR>', { desc = 'Toggle floating terminal' })



-- Git Blame
km('n', '<leader>gb', function()
  require('gitsigns').blame_line { full = true }
end, { desc = 'Git Blame Line' })

-- Telescope
local builtin = require('telescope.builtin')

km('n', '<leader>ff', builtin.find_files, { desc = "Find files" })
km('n', '<leader>fg', builtin.live_grep,  { desc = "Live grep project" })
km('n', '<leader>fb', builtin.buffers,    { desc = "Find buffers" })
km('n', '<leader>fh', builtin.help_tags,  { desc = "Find help" })

-- Formatter
km('n', '<leader>f', function()
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


