-- Enhanced Node.js/TypeScript development tools
return {
  -- Package.json management and npm/yarn integration
  {
    "vuki656/package-info.nvim",
    dependencies = "MunifTanjim/nui.nvim",
    event = { "BufRead package.json" },
    config = function()
      require("package-info").setup({
        highlights = {
          up_to_date = { fg = "#3C4048" },
          outdated = { fg = "#fc7b7b" },
        },
        icons = {
          enable = true,
          style = {
            up_to_date = "|  ",
            outdated = "|  ",
          },
        },
        autostart = true,
        hide_up_to_date = false,
        hide_unstable_versions = false,
      })
      
      -- Keymaps for package management
      vim.keymap.set("n", "<leader>ns", require("package-info").show, { desc = "Show package versions" })
      vim.keymap.set("n", "<leader>nc", require("package-info").hide, { desc = "Hide package versions" })
      vim.keymap.set("n", "<leader>nt", require("package-info").toggle, { desc = "Toggle package versions" })
      vim.keymap.set("n", "<leader>nu", require("package-info").update, { desc = "Update package on line" })
      vim.keymap.set("n", "<leader>nd", require("package-info").delete, { desc = "Delete package on line" })
      vim.keymap.set("n", "<leader>ni", require("package-info").install, { desc = "Install package on line" })
      vim.keymap.set("n", "<leader>np", require("package-info").change_version, { desc = "Change package version" })
    end,
  },

  -- Enhanced Jest testing support
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/neotest-jest",
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-jest")({
            jestCommand = "npm test --",
            jestConfigFile = "jest.config.js",
            env = { CI = true },
            cwd = function(path)
              return vim.fn.getcwd()
            end,
          }),
        },
        quickfix = {
          open = false,
        },
      })
      
      -- Test keymaps (using different keys to avoid conflicts)
      vim.keymap.set("n", "<leader>tr", function() require("neotest").run.run() end, { desc = "Run nearest test" })
      vim.keymap.set("n", "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, { desc = "Run tests in file" })
      vim.keymap.set("n", "<leader>ta", function() require("neotest").run.run(vim.fn.getcwd()) end, { desc = "Run all tests" })
      vim.keymap.set("n", "<leader>ts", function() require("neotest").summary.toggle() end, { desc = "Toggle test summary" })
      vim.keymap.set("n", "<leader>to", function() require("neotest").output.open({ enter = true }) end, { desc = "Open test output" })
      vim.keymap.set("n", "<leader>tO", function() require("neotest").output_panel.toggle() end, { desc = "Toggle test output panel" })
    end,
  },

  -- Auto-import and organize imports
  {
    "stevanmilic/nvim-lspimport",
    config = function()
      -- Auto import on completion
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client and client.name == "ts_ls" then
            vim.keymap.set("n", "<leader>ai", function()
              require("lspimport").import()
            end, { buffer = args.buf, desc = "Auto import" })
          end
        end,
      })
    end,
  },
}
