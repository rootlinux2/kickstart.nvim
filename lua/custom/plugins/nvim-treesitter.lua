return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
    "windwp/nvim-ts-autotag",
  },
  config = function()
    require("nvim-treesitter.configs").setup {
      ensure_installed = { 
        "lua", "typescript", "javascript", "json", "html", "css", "scss",
        "tsx", "prisma", "graphql", "yaml", "toml", "dockerfile",
        "bash", "markdown", "markdown_inline", "regex", "jsdoc"
      },
      
      highlight = { 
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      
      indent = { enable = true },
      
      -- Enhanced incremental selection for JS/TS
      incremental_selection = {
        enable = true,
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
          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
            ["ap"] = "@parameter.outer",
            ["ip"] = "@parameter.inner",
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            ["]m"] = "@function.outer",
            ["]]"] = "@class.outer",
          },
          goto_next_end = {
            ["]M"] = "@function.outer",
            ["]["] = "@class.outer",
          },
          goto_previous_start = {
            ["[m"] = "@function.outer",
            ["[["] = "@class.outer",
          },
          goto_previous_end = {
            ["[M"] = "@function.outer",
            ["[]"] = "@class.outer",
          },
        },
      },
      
      -- Auto-tagging for JSX/TSX
      autotag = {
        enable = true,
        filetypes = { "html", "xml", "tsx", "javascriptreact", "typescriptreact" },
      },
    }
  end,
}

