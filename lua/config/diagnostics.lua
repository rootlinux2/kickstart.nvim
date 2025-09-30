-- Modern diagnostics configuration with enhanced features
vim.diagnostic.config({
  severity_sort = true,
  virtual_text = {
    source = "if_many",
    prefix = function(diagnostic)
      local icons = { E = "", W = "", I = "", H = "" }
      for d, icon in pairs(icons) do
        if diagnostic.severity == vim.diagnostic.severity[d] then
          return icon
        end
      end
    end,
  },
  float = { 
    border = 'rounded', 
    source = 'if_many',
    header = '',
    prefix = '',
    focusable = false,
  },
  underline = { 
    severity = { min = vim.diagnostic.severity.WARN }
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN] = "",
      [vim.diagnostic.severity.HINT] = "",
      [vim.diagnostic.severity.INFO] = "",
    },
  },
  update_in_insert = false,
  jump = {
    float = true,
  },
})

-- Enhanced diagnostic navigation
vim.keymap.set('n', '[d', function()
  vim.diagnostic.goto_prev({ float = true })
end, { desc = 'Previous diagnostic' })

vim.keymap.set('n', ']d', function()
  vim.diagnostic.goto_next({ float = true })
end, { desc = 'Next diagnostic' })

vim.keymap.set('n', '[e', function()
  vim.diagnostic.goto_prev({ 
    severity = vim.diagnostic.severity.ERROR,
    float = true 
  })
end, { desc = 'Previous error' })

vim.keymap.set('n', ']e', function()
  vim.diagnostic.goto_next({ 
    severity = vim.diagnostic.severity.ERROR,
    float = true 
  })
end, { desc = 'Next error' })
