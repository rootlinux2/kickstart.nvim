return {
  -- Use iamcco/markdown-preview.nvim for rendering Markdown
  "iamcco/markdown-preview.nvim",
  build = "cd app && npm install", -- Ensure dependencies are installed
  ft = "markdown",
  config = function()
    -- Automatically start the preview when opening a Markdown file
    vim.g.mkdp_auto_start = 1

    -- Optional: Keymap to manually start the preview
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "markdown",
      callback = function(args)
        vim.keymap.set("n", "<leader>mp", "<cmd>MarkdownPreview<CR>", {
          desc = "Start Markdown Preview",
          buffer = args.buf,
        })
      end,
    })
  end,
}