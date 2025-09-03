local km = vim.keymap.set

-- Clear highlights
km('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlights' })

-- Diagnostics
km('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Tabs
km('n', '<leader>tn', ':tabnext<CR>', { desc = 'Next Tab' })
km('n', '<leader>tp', ':tabprevious<CR>', { desc = 'Previous Tab' })

-- Move lines
km('n', '<A-j>', ':m .+1<CR>==', { desc = 'Move line down' })
km('n', '<A-k>', ':m .-2<CR>==', { desc = 'Move line up' })
km('v', '<A-j>', ":m '>+1<CR>gv=gv", { desc = 'Move selection down' })
km('v', '<A-k>', ":m '<-2<CR>gv=gv", { desc = 'Move selection up' })

-- Window navigation
km('n', '<C-h>', '<C-w><C-h>', { desc = 'Left window' })
km('n', '<C-l>', '<C-w><C-l>', { desc = 'Right window' })
km('n', '<C-j>', '<C-w><C-j>', { desc = 'Lower window' })
km('n', '<C-k>', '<C-w><C-k>', { desc = 'Upper window' })

-- Terminal
km('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

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

