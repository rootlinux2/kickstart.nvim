-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('highlight_yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Setup PATH for cargo binaries on VimEnter
vim.api.nvim_create_autocmd('VimEnter', {
  group = vim.api.nvim_create_augroup('setup_path', { clear = true }),
  callback = function()
    local home = os.getenv("HOME")
    if home then
      local cargo_bin = home .. "/.cargo/bin"
      local current_path = vim.env.PATH or ""
      
      -- Add cargo bin to PATH if not already present
      if not string.match(current_path, "%.cargo/bin") then
        vim.env.PATH = cargo_bin .. ":" .. current_path
      end
    end
  end,
})

-- LSP inlay hints
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('lsp_inlay_hints', { clear = true }),
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and vim.lsp.inlay_hint then
      vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
    end
  end,
})

-- .env file support
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = vim.api.nvim_create_augroup('env_files', { clear = true }),
  pattern = { "*.env*", ".env*" },
  callback = function()
    vim.bo.filetype = "sh"
    
    -- Add basic .env syntax highlighting
    vim.cmd([[
      syntax match envComment "^#.*$"
      syntax match envKey "^[A-Za-z_][A-Za-z0-9_]*"
      syntax match envEquals "="
      syntax match envValue "=.*$"
      
      highlight def link envComment Comment
      highlight def link envKey Identifier
      highlight def link envEquals Operator
      highlight def link envValue String
    ]])
  end,
})
