local M = {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "antoinemadec/FixCursorHold.nvim",
    "vim-test/vim-test",
    "nvim-neotest/neotest-vim-test",
    "rouge8/neotest-rust",
    "nvim-neotest/nvim-nio",
  },
  event = "VeryLazy",
}

M.config = function()
  require("neotest").setup {
    adapters = {
      require "neotest-rust" { allow_file_types = { "rust" } },
    },
  }
end

return M
