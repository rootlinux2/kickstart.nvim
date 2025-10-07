return {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPost", "BufNewFile" },
  cmd = { "TSInstall", "TSUpdate", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
  build = ":TSUpdate",
  dependencies = {
    {
      "nvim-treesitter/nvim-treesitter-textobjects",
      event = "VeryLazy",
    },
    {
      "windwp/nvim-ts-autotag",
      event = "InsertEnter",
      ft = { "html", "xml", "tsx", "jsx", "javascriptreact", "typescriptreact", "vue", "svelte" },
    },
  },
  config = function()
    -- Performance: disable for large files
    local function disable_for_large_files(_, buf)
      local max_filesize = 100 * 1024 -- 100 KB
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      if ok and stats and stats.size > max_filesize then
        return true
      end
    end

    require("nvim-treesitter.configs").setup {
      ensure_installed = { 
        "lua", "typescript", "javascript", "json", "html", "css", "scss",
        "tsx", "prisma", "graphql", "yaml", "toml", "dockerfile",
        "bash", "markdown", "markdown_inline", "regex", "jsdoc", "vim", "vimdoc",
        "python", "rust", "go"
      },
      
      -- Auto-install parsers when entering buffer
      auto_install = true,
      
      highlight = { 
        enable = true,
        disable = disable_for_large_files,
        additional_vim_regex_highlighting = false,
      },
      
      indent = { 
        enable = true,
        disable = disable_for_large_files,
      },
      
      -- Enhanced incremental selection for JS/TS
      incremental_selection = {
        enable = true,
        disable = disable_for_large_files,
        keymaps = {
          init_selection = "gnn",
          node_incremental = "grn",
          node_decremental = "grm",
          scope_incremental = "grc",
        },
      },
      
      -- Text objects for better navigation
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          disable = disable_for_large_files,
          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
            ["ap"] = "@parameter.outer",
            ["ip"] = "@parameter.inner",
            ["ab"] = "@block.outer",
            ["ib"] = "@block.inner",
            ["al"] = "@loop.outer",
            ["il"] = "@loop.inner",
            ["ai"] = "@conditional.outer",
            ["ii"] = "@conditional.inner",
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          disable = disable_for_large_files,
          goto_next_start = {
            ["]m"] = "@function.outer",
            ["]]"] = "@class.outer",
            ["]b"] = "@block.outer",
            ["]l"] = "@loop.outer",
            ["]i"] = "@conditional.outer",
          },
          goto_next_end = {
            ["]M"] = "@function.outer",
            ["]["] = "@class.outer",
            ["]B"] = "@block.outer",
            ["]L"] = "@loop.outer",
            ["]I"] = "@conditional.outer",
          },
          goto_previous_start = {
            ["[m"] = "@function.outer",
            ["[["] = "@class.outer",
            ["[b"] = "@block.outer",
            ["[l"] = "@loop.outer",
            ["[i"] = "@conditional.outer",
          },
          goto_previous_end = {
            ["[M"] = "@function.outer",
            ["[]"] = "@class.outer",
            ["[B"] = "@block.outer",
            ["[L"] = "@loop.outer",
            ["[I"] = "@conditional.outer",
          },
        },
        swap = {
          enable = true,
          disable = disable_for_large_files,
          swap_next = {
            ["<leader>sn"] = "@parameter.inner",
            ["<leader>sm"] = "@function.outer",
          },
          swap_previous = {
            ["<leader>sp"] = "@parameter.inner",
            ["<leader>sM"] = "@function.outer",
          },
        },
      },
      
      -- Auto-tagging for JSX/TSX
      autotag = {
        enable = true,
        enable_rename = true,
        enable_close = true,
        enable_close_on_slash = true,
        filetypes = { 
          "html", "xml", "tsx", "jsx", "javascriptreact", "typescriptreact",
          "vue", "svelte", "astro", "php", "erb", "handlebars"
        },
      },
    }

    -- Set foldmethod to expr for better folding with treesitter
    vim.api.nvim_create_autocmd("BufReadPost", {
      group = vim.api.nvim_create_augroup("treesitter_fold", { clear = true }),
      callback = function()
        if vim.bo.filetype ~= "" then
          vim.opt_local.foldmethod = "expr"
          vim.opt_local.foldexpr = "nvim_treesitter#foldexpr()"
          vim.opt_local.foldenable = false -- Don't fold by default
        end
      end,
    })
  end,
}

