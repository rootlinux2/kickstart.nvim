return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    build = "make tiktoken",
    branch = "main",
    opts = {
      -- See Configuration section for options
    },
  },
}
