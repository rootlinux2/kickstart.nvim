return {

  -- Autocompletion
  'hrsh7th/nvim-cmp',
  event = "InsertEnter",
  dependencies = {
    'hrsh7th/cmp-nvim-lsp', -- LSP source for nvim-cmp
    'hrsh7th/cmp-buffer',   -- Buffer completions
    'hrsh7th/cmp-path',     -- Path completions
    {
      'L3MON4D3/LuaSnip',
      version = "v2.*",
      build = "make install_jsregexp", -- Install jsregexp for advanced transformations
      dependencies = {
        'rafamadriz/friendly-snippets', -- Predefined snippets
      },
    },
    'saadparwaiz1/cmp_luasnip', -- LuaSnip completion source
  },
  config = function()
    local cmp = require 'cmp'
    local luasnip = require 'luasnip'
    
    -- Load friendly-snippets
    require("luasnip.loaders.from_vscode").lazy_load()
    
    cmp.setup {
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert {
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping.confirm {
          behavior = cmp.ConfirmBehavior.Replace,
          select = true,
        },
        ['<Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.locally_jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { 'i', 's' }),
      },
      sources = cmp.config.sources {
        { name = 'nvim_lsp' },
        { name = 'luasnip' }, -- Add luasnip source
        { name = 'buffer' },
        { name = 'path' },
      },
      formatting = {
        format = function(entry, vim_item)
          -- Add source indicator
          vim_item.menu = ({
            nvim_lsp = "[LSP]",
            luasnip = "[Snippet]",
            buffer = "[Buffer]",
            path = "[Path]",
          })[entry.source.name]
          return vim_item
        end,
      },
    }
  end,
}
