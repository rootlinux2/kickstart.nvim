-- Basic Neovim options
local o = vim.opt

-- Performance optimizations
o.lazyredraw = true -- Don't redraw while executing macros
o.ttyfast = true -- Faster terminal connection
o.regexpengine = 1 -- Use old regexp engine (faster for some cases)
o.synmaxcol = 300 -- Limit syntax highlighting to 300 columns
o.redrawtime = 1500 -- Allow more time for loading syntax on large files

o.termguicolors = true
o.shell = '/usr/bin/zsh'
o.number = true
o.relativenumber = true
o.mouse = 'a'
o.showmode = false
o.clipboard = 'unnamedplus'
o.breakindent = true
o.undofile = true
o.ignorecase = true
o.smartcase = true
o.signcolumn = 'yes'
o.updatetime = 250
o.timeoutlen = 300
o.splitright = true
o.splitbelow = true
o.list = true
o.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
o.inccommand = 'split'
o.cursorline = true
o.scrolloff = 10
o.confirm = true
o.foldmethod = 'expr'
o.foldexpr = 'nvim_treesitter#foldexpr()'
o.foldlevel = 99
o.swapfile = false

--colorscheme
-- vim.cmd [[colorscheme tokyonight-night]]

-- Additional UI improvements
o.conceallevel = 2 -- Hide concealed text unless cursor is on the line
o.concealcursor = 'nc' -- Hide concealed text in normal and command mode
o.wrap = false -- Don't wrap lines
o.linebreak = true -- Break lines at word boundaries
o.breakindentopt = 'shift:2'
o.showbreak = '↪ ' -- Show line break indicator

-- Better completion experience
o.completeopt = { 'menu', 'menuone', 'noselect', 'noinsert' }
o.pumheight = 10 -- Maximum number of items in popup menu

-- Search improvements
o.hlsearch = true -- Highlight search results
o.incsearch = true -- Incremental search

-- Window and buffer behavior
o.splitkeep = 'screen' -- Keep the same relative cursor position when splitting
o.shortmess:append 'c' -- Don't show completion messages
o.formatoptions:remove { 'c', 'r', 'o' } -- Don't auto-wrap comments

-- Memory and performance
o.maxmempattern = 20000 -- Increase pattern memory
o.history = 1000 -- Command history
o.undolevels = 10000 -- More undo levels
