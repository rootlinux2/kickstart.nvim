-- Highlight on yank with enhanced options
vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('highlight_yank', { clear = true }),
  callback = function()
    vim.hl.on_yank({ timeout = 150, higroup = 'Visual' })
  end,
})

-- Auto-save when focus is lost
vim.api.nvim_create_autocmd({ 'FocusLost', 'BufLeave' }, {
  group = vim.api.nvim_create_augroup('auto_save', { clear = true }),
  callback = function()
    if vim.bo.modified and not vim.bo.readonly and vim.fn.expand('%') ~= '' and vim.bo.buftype == '' then
      vim.api.nvim_command('silent update')
    end
  end,
})

-- Auto-resize splits when vim is resized
vim.api.nvim_create_autocmd('VimResized', {
  group = vim.api.nvim_create_augroup('auto_resize', { clear = true }),
  callback = function()
    vim.cmd('tabdo wincmd =')
  end,
})

-- Close some filetypes with <q>
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('close_with_q', { clear = true }),
  pattern = { 'help', 'lspinfo', 'man', 'qf', 'startuptime', 'checkhealth' },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = event.buf, silent = true })
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
