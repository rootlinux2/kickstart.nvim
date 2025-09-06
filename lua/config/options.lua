-- Basic Neovim options
local o = vim.opt

o.termguicolors = true
o.shell = "/usr/bin/zsh"
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
  foldopen = '',       -- Fold open indicator
  foldclose = '',      -- Fold close indicator
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

-- Window and buffer behavior
o.splitkeep = 'screen' -- Keep the same relative cursor position when splitting
o.shortmess:append('c') -- Don't show completion messages
o.formatoptions:remove({'c', 'r', 'o'}) -- Don't auto-wrap comments
