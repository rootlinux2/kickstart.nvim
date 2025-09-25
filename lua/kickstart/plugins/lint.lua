return {

  { -- Linting
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require 'lint'
      
      -- Function to check if a command exists
      local function command_exists(cmd)
        local handle = io.popen('which ' .. cmd .. ' 2>/dev/null')
        local result = handle:read('*a')
        handle:close()
        return result ~= ''
      end
      
      -- Choose the best available ESLint linter
      local eslint_linter = 'eslint'
      if command_exists('eslint_d') then
        eslint_linter = 'eslint_d'
      end
      
      lint.linters_by_ft = {
        markdown = { 'markdownlint' },
        javascript = { eslint_linter },
        typescript = { eslint_linter },
        javascriptreact = { eslint_linter },
        typescriptreact = { eslint_linter },
      }

      -- To allow other plugins to add linters to require('lint').linters_by_ft,
      -- instead set linters_by_ft like this:
      -- lint.linters_by_ft = lint.linters_by_ft or {}
      -- lint.linters_by_ft['markdown'] = { 'markdownlint' }
      --
      -- However, note that this will enable a set of default linters,
      -- which will cause errors unless these tools are available:
      -- {
      --   clojure = { "clj-kondo" },
      --   dockerfile = { "hadolint" },
      --   inko = { "inko" },
      --   janet = { "janet" },
      --   json = { "jsonlint" },
      --   markdown = { "vale" },
      --   rst = { "vale" },
      --   ruby = { "ruby" },
      --   terraform = { "tflint" },
      --   text = { "vale" }
      -- }
      --
      -- You can disable the default linters by setting their filetypes to nil:
      -- lint.linters_by_ft['clojure'] = nil
      -- lint.linters_by_ft['dockerfile'] = nil
      -- lint.linters_by_ft['inko'] = nil
      -- lint.linters_by_ft['janet'] = nil
      -- lint.linters_by_ft['json'] = nil
      -- lint.linters_by_ft['markdown'] = nil
      -- lint.linters_by_ft['rst'] = nil
      -- lint.linters_by_ft['ruby'] = nil
      -- lint.linters_by_ft['terraform'] = nil
      -- lint.linters_by_ft['text'] = nil

      -- Create autocommand which carries out the actual linting
      -- on the specified events.
      local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = lint_augroup,
        callback = function()
          -- Only run the linter in buffers that you can modify in order to
          -- avoid superfluous noise, notably within the handy LSP pop-ups that
          -- describe the hovered symbol using Markdown.
          if vim.bo.modifiable then
            -- Wrap in pcall to prevent errors from breaking Neovim
            local ok, err = pcall(function()
              lint.try_lint()
            end)
            if not ok then
              vim.notify('Linting error: ' .. tostring(err), vim.log.levels.WARN)
            end
          end
        end,
      })

    end,
  },

  { -- Git integration
    'tpope/vim-fugitive',
    cmd = { 'Git', 'Gstatus', 'Gcommit', 'Gpush', 'Gpull' },

  },
}
