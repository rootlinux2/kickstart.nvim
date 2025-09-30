-- Enhanced keymaps for new plugin features
local km = vim.keymap.set

-- Session management (persistence.nvim)
km("n", "<leader>qs", function() require("persistence").load() end, { desc = "Restore session" })
km("n", "<leader>ql", function() require("persistence").load({ last = true }) end, { desc = "Restore last session" })
km("n", "<leader>qd", function() require("persistence").stop() end, { desc = "Don't save session" })

-- Search and replace (nvim-spectre)
km("n", "<leader>S", function() require("spectre").toggle() end, { desc = "Toggle Spectre" })
km("n", "<leader>sw", function() require("spectre").open_visual({select_word=true}) end, { desc = "Search current word" })
km("v", "<leader>sw", function() require("spectre").open_visual() end, { desc = "Search current word" })
km("n", "<leader>sp", function() require("spectre").open_file_search({select_word=true}) end, { desc = "Search on current file" })

-- Code annotation (neogen)
km("n", "<leader>nf", function() require('neogen').generate({ type = "func" }) end, { desc = "Generate function annotation" })
km("n", "<leader>nt", function() require('neogen').generate({ type = "type" }) end, { desc = "Generate type annotation" })
km("n", "<leader>nc", function() require('neogen').generate({ type = "class" }) end, { desc = "Generate class annotation" })

-- Enhanced terminal (toggleterm.nvim)
km("n", "<C-\\>", "<cmd>ToggleTerm<cr>", { desc = "Toggle floating terminal" })
km("t", "<C-\\>", "<cmd>ToggleTerm<cr>", { desc = "Toggle floating terminal" })

-- Better folding (nvim-ufo)
km('n', 'zR', function() require('ufo').openAllFolds() end, { desc = "Open all folds" })
km('n', 'zM', function() require('ufo').closeAllFolds() end, { desc = "Close all folds" })

-- Enhanced increment/decrement (dial.nvim) - already configured in plugin

-- Marks (marks.nvim) - uses default mappings

-- Auto-save toggle
km("n", "<leader>as", function()
  if vim.g.auto_save_enabled then
    require("auto-save").off()
    vim.g.auto_save_enabled = false
    print("Auto-save disabled")
  else
    require("auto-save").on()
    vim.g.auto_save_enabled = true
    print("Auto-save enabled")
  end
end, { desc = "Toggle auto-save" })

-- Enhanced telescope shortcuts
km("n", "<leader>fp", function() 
  require("telescope").extensions.projects.projects{}
end, { desc = "Find projects" })

return {}