-- Modern development utilities and quality of life improvements
return {
  -- Better quickfix/location list
  {
    "kevinhwang91/nvim-bqf",
    event = "VeryLazy",
    ft = "qf",
    config = function()
      require("bqf").setup({
        auto_enable = true,
        auto_resize_height = true,
        preview = {
          win_height = 12,
          win_vheight = 12,
          delay_syntax = 80,
          border_chars = { "┃", "━", "┏", "┓", "┗", "┛", "┣", "┫", "━" },
        },
        func_map = {
          vsplit = "",
          ptogglemode = "z,",
          stoggleup = "",
        },
        filter = {
          fzf = {
            action_for = { ["ctrl-s"] = "split" },
            extra_opts = { "--bind", "ctrl-o:toggle-all", "--prompt", "> " }
          }
        }
      })
    end,
  },

  -- Better search and replace
  {
    "nvim-pack/nvim-spectre",
    build = false,
    cmd = "Spectre",
    opts = { open_cmd = "noswapfile vnew" },
    keys = {
      { "<leader>S", function() require("spectre").toggle() end, desc = "Toggle Spectre" },
      { "<leader>sw", function() require("spectre").open_visual({select_word=true}) end, desc = "Search current word" },
      { "<leader>sw", function() require("spectre").open_visual() end, mode = "v", desc = "Search current word" },
      { "<leader>sp", function() require("spectre").open_file_search({select_word=true}) end, desc = "Search on current file" },
    },
  },

  -- Auto-detect indentation
  {
    "tpope/vim-sleuth",
    event = { "BufReadPre", "BufNewFile" },
  },

  -- Enhanced f/F/t/T motions
  {
    "ggandor/leap.nvim",
    event = "VeryLazy",
    config = function()
      require('leap').add_default_mappings()
      require('leap').opts.safe_labels = 'sfnut/SFNLHMUGTZ?'
      require('leap').opts.labels = 'sfnjklhodweimbuyvrgtaqpcxz/SFNJKLHODWEIMBUYVRGTAQPCXZ?'
    end,
  },

  -- Surround operations
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        keymaps = {
          insert = "<C-g>s",
          insert_line = "<C-g>S",
          normal = "ys",
          normal_cur = "yss",
          normal_line = "yS",
          normal_cur_line = "ySS",
          visual = "S",
          visual_line = "gS",
          delete = "ds",
          change = "cs",
          change_line = "cS",
        },
      })
    end,
  },

  -- Multiple cursors
  {
    "mg979/vim-visual-multi",
    event = "VeryLazy",
    config = function()
      vim.g.VM_maps = {
        ['Find Under'] = '<C-d>',
        ['Find Subword Under'] = '<C-d>',
      }
      vim.g.VM_mouse_mappings = 1
      vim.g.VM_theme = 'iceblue'
    end,
  },

  -- Better terminal integration
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    cmd = { "ToggleTerm", "TermExec" },
    keys = {
      { "<C-\\>", "<cmd>ToggleTerm<cr>", desc = "Toggle terminal" },
      { "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", desc = "Toggle floating terminal" },
      { "<leader>th", "<cmd>ToggleTerm direction=horizontal<cr>", desc = "Toggle horizontal terminal" },
      { "<leader>tv", "<cmd>ToggleTerm direction=vertical size=80<cr>", desc = "Toggle vertical terminal" },
    },
    config = function()
      require("toggleterm").setup({
        size = 20,
        open_mapping = [[<C-\>]],
        hide_numbers = true,
        shade_terminals = true,
        shading_factor = 2,
        start_in_insert = true,
        insert_mappings = true,
        persist_size = true,
        direction = "float",
        close_on_exit = true,
        shell = vim.o.shell,
        float_opts = {
          border = "curved",
          winblend = 0,
          highlights = {
            border = "Normal",
            background = "Normal",
          },
        },
      })

      -- Terminal mode keymaps
      function _G.set_terminal_keymaps()
        local opts = {buffer = 0}
        vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
        vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
        vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
        vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
        vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
        vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
        vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
      end

      -- Use modern autocmd API instead of vim.cmd
      vim.api.nvim_create_autocmd("TermOpen", {
        pattern = "term://*",
        callback = function()
          set_terminal_keymaps()
        end,
      })

      -- Terminal specific commands
      local Terminal = require('toggleterm.terminal').Terminal

      -- Lazygit integration
      local lazygit = Terminal:new({
        cmd = "lazygit",
        dir = "git_dir",
        direction = "float",
        float_opts = {
          border = "double",
        },
        on_open = function(term)
          vim.cmd("startinsert!")
          vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", {noremap = true, silent = true})
        end,
        on_close = function(term)
          vim.cmd("startinsert!")
        end,
      })

      function _LAZYGIT_TOGGLE()
        lazygit:toggle()
      end

      vim.keymap.set("n", "<leader>gg", "<cmd>lua _LAZYGIT_TOGGLE()<CR>", {noremap = true, silent = true, desc = "Lazygit"})

      -- Node.js REPL
      local node = Terminal:new({
        cmd = "node",
        direction = "float",
        close_on_exit = false,
      })

      function _NODE_TOGGLE()
        node:toggle()
      end

      vim.keymap.set("n", "<leader>tn", "<cmd>lua _NODE_TOGGLE()<CR>", {noremap = true, silent = true, desc = "Node REPL"})

      -- Python REPL
      local python = Terminal:new({
        cmd = "python3",
        direction = "float",
        close_on_exit = false,
      })

      function _PYTHON_TOGGLE()
        python:toggle()
      end

      vim.keymap.set("n", "<leader>tp", "<cmd>lua _PYTHON_TOGGLE()<CR>", {noremap = true, silent = true, desc = "Python REPL"})
    end,
  },

  -- Project management
  {
    "ahmedkhalf/project.nvim",
    event = "VeryLazy",
    config = function()
      require("project_nvim").setup({
        detection_methods = { "lsp", "pattern" },
        patterns = { 
          ".git", "_darcs", ".hg", ".bzr", ".svn", 
          "Makefile", "package.json", "pom.xml", "Cargo.toml",
          "go.mod", "requirements.txt", "pyrproject.toml"
        },
        ignore_lsp = {},
        exclude_dirs = {},
        show_hidden = false,
        silent_chdir = true,
        scope_chdir = 'global',
        datapath = vim.fn.stdpath("data"),
      })

      -- Telescope integration
      pcall(require('telescope').load_extension, 'projects')
    end,
  },

  -- Enhanced word motions
  {
    "chaoren/vim-wordmotion",
    event = "VeryLazy",
    config = function()
      vim.g.wordmotion_prefix = '<Leader>'
    end,
  },

  -- Better buffer deletion
  {
    "famiu/bufdelete.nvim",
    cmd = { "Bdelete", "Bwipeout" },
    keys = {
      { "<leader>bd", function() require("bufdelete").bufdelete(0, false) end, desc = "Delete buffer" },
      { "<leader>bD", function() require("bufdelete").bufdelete(0, true) end, desc = "Delete buffer (force)" },
    },
  },

  -- Enhanced marks
  {
    "chentoast/marks.nvim",
    event = "VeryLazy",
    config = function()
      require('marks').setup({
        default_mappings = true,
        builtin_marks = { ".", "<", ">", "^" },
        cyclic = true,
        force_write_shada = false,
        refresh_interval = 250,
        sign_priority = { lower=10, upper=15, builtin=8, bookmark=20 },
        excluded_filetypes = {
          "qf",
          "NvimTree",
          "toggleterm",
          "TelescopePrompt",
          "alpha",
          "netrw",
        },
        bookmark_0 = {
          sign = "⚑",
          virt_text = "hello world",
          annotate = false,
        },
        mappings = {}
      })
    end,
  },

  -- Enhanced undo
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    keys = {
      { "<leader>u", "<cmd>UndotreeToggle<cr>", desc = "Toggle undotree" },
    },
    config = function()
      vim.g.undotree_WindowLayout = 2
      vim.g.undotree_SplitWidth = 30
      vim.g.undotree_SetFocusWhenToggle = 1
    end,
  },

  -- Session management improvements
  {
    "rmagatti/auto-session",
    config = function()
      require("auto-session").setup({
        log_level = "error",
        auto_session_enable_last_session = false,
        auto_session_root_dir = vim.fn.stdpath('data').."/sessions/",
        auto_session_enabled = true,
        auto_save_enabled = nil,
        auto_restore_enabled = nil,
        auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/"},
        auto_session_use_git_branch = false,
      })
    end,
  },
}