-- Basic Neovim options
local o = vim.opt

o.termguicolors = true
-- Use the correct shell path for your system
o.shell = vim.fn.executable('zsh') == 1 and vim.fn.exepath('zsh') or vim.o.shell
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

-- Transparency and visual enhancements
o.pumblend = 10        -- Popup menu transparency (0-30)
o.winblend = 10        -- Floating window transparency (0-30)
o.showtabline = 2      -- Always show tabline
o.laststatus = 3       -- Global statusline
o.fillchars = {
  eob = ' ',           -- End of buffer character (removes ~)
  fold = ' ',          -- Fold character
  foldsep = ' ',       -- Fold separator
  foldopen = '▼',      -- Fold open indicator
  foldclose = '▶',     -- Fold close indicator
  diff = '╱',          -- Diff fill character
  msgsep = '─',        -- Message separator
  horiz = '─',         -- Horizontal separator
  horizup = '┴',       -- Horizontal up separator
  horizdown = '┬',     -- Horizontal down separator
  vert = '│',          -- Vertical separator
  vertleft = '┤',      -- Vertical left separator
  vertright = '├',     -- Vertical right separator
  verthoriz = '┼',     -- Vertical horizontal separator
}

-- Additional UI improvements
o.conceallevel = 2     -- Hide concealed text unless cursor is on the line
o.concealcursor = 'nc' -- Hide concealed text in normal and command mode
o.wrap = false         -- Don't wrap lines
o.linebreak = true     -- Break lines at word boundaries
o.breakindentopt = 'shift:2'
o.showbreak = '↪ '     -- Show line break indicator

-- Better completion experience
o.completeopt = { 'menu', 'menuone', 'noselect', 'noinsert' }
o.pumheight = 10       -- Maximum number of items in popup menu

-- Search improvements
o.hlsearch = true      -- Highlight search results
o.incsearch = true     -- Incremental search

-- Window and buffer behavior\no.splitkeep = 'screen' -- Keep the same relative cursor position when splitting\no.shortmess:append('c') -- Don't show completion messages\no.formatoptions:remove({'c', 'r', 'o'}) -- Don't auto-wrap comments\n\n-- Performance optimizations (Neovim 0.10+)\no.lazyredraw = false -- Don't redraw during macros (can cause issues with modern plugins)\no.ttyfast = true -- Fast terminal connection\no.synmaxcol = 300 -- Don't syntax highlight very long lines\no.redrawtime = 1500 -- Time in milliseconds for redrawing the display\no.ttimeoutlen = 10 -- Time in milliseconds to wait for a key code sequence\n\n-- Modern clipboard integration\nif vim.fn.has('unnamedplus') == 1 then\n  o.clipboard:append('unnamedplus')\nend\n\n-- Better backup and undo behavior\no.backup = false\no.writebackup = false\no.undodir = vim.fn.stdpath('cache') .. '/undo'\no.backupdir = vim.fn.stdpath('cache') .. '/backup'\no.directory = vim.fn.stdpath('cache') .. '/swap'\n\n-- Create cache directories if they don't exist\nvim.fn.mkdir(vim.fn.stdpath('cache') .. '/undo', 'p')\nvim.fn.mkdir(vim.fn.stdpath('cache') .. '/backup', 'p')\nvim.fn.mkdir(vim.fn.stdpath('cache') .. '/swap', 'p')
