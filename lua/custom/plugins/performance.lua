-- Startup time monitoring and lazy loading optimization
return {
  -- Startup time profiler
  {
    "dstein64/vim-startuptime",
    cmd = "StartupTime",
    config = function()
      vim.g.startuptime_tries = 10
    end,
  },

  -- Session management for faster project switching
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {
      dir = vim.fn.expand(vim.fn.stdpath("state") .. "/sessions/"),
      options = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp" },
      pre_save = nil,
    },
    keys = {
      { "<leader>ss", function() require("persistence").load() end, desc = "Restore Session" },
      { "<leader>sl", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
      { "<leader>sd", function() require("persistence").stop() end, desc = "Don't Save Current Session" },
    },
  },

  -- Better filetype detection for faster loading
  {
    "nathom/filetype.nvim",
    lazy = false,
    priority = 9999,
    opts = {
      overrides = {
        extensions = {
          tf = "terraform",
          tfvars = "terraform",
          tfstate = "json",
        },
        literal = {
          [".gitignore"] = "gitignore",
          ["Dockerfile"] = "dockerfile",
          ["docker-compose.yml"] = "yaml.docker-compose",
        },
        complex = {
          [".*git/config"] = "gitconfig",
          [".*%.env%..*"] = "sh",
        },
      },
    },
  },
}