return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  config = function()
    require('which-key').setup({
      preset = "modern",
      delay = 300,
      plugins = {
        marks = true,
        registers = true,
        spelling = {
          enabled = true,
          suggestions = 20,
        },
        presets = {
          operators = true,
          motions = true,
          text_objects = true,
          windows = true,
          nav = true,
          z = true,
          g = true,
        },
      },
      win = {
        border = "rounded",
        padding = { 1, 2 },
        wo = {
          winblend = 10,
        },
      },
      layout = {
        height = { min = 4, max = 25 },
        width = { min = 20, max = 50 },
        spacing = 3,
        align = "left",
      },
      keys = {
        scroll_down = "<c-d>",
        scroll_up = "<c-u>",
      },
      show_help = true,
      show_keys = true,
      disable = {
        bt = {},
        ft = { "TelescopePrompt" },
      },
    })
    
    -- Register key groups for better organization
    require('which-key').add({
      { "<leader>b", group = "[B]uffer" },
      { "<leader>c", group = "[C]ode" },
      { "<leader>d", group = "[D]ebug" },
      { "<leader>f", group = "[F]ind" },
      { "<leader>g", group = "[G]it" },
      { "<leader>h", group = "[H]arpoon" },
      { "<leader>l", group = "[L]SP" },
      { "<leader>n", group = "[N]ode/NPM" },
      { "<leader>r", group = "[R]ename" },
      { "<leader>s", group = "[S]earch" },
      { "<leader>t", group = "[T]est/Toggle" },
      { "<leader>w", group = "[W]indow" },
      { "<leader>x", group = "[X]Trouble" },
      { "<leader>y", group = "[Y]arn" },
    })
  end,
}
