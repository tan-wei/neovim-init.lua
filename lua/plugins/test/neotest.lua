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
    "alfaix/neotest-gtest",
  },
  event = "VeryLazy",
}

M.config = function()
  require("neotest").setup {
    adapters = {
      require "neotest-rust" { allow_file_types = { "rust" } },
      require("neotest-gtest").setup {
        is_test_file = function(file)
          return string.find(file, "[tT][eE][sS][tT][sS]?_") ~= nil
            or string.find(file, "_[tT][eE][sS][tT][sS]?") ~= nil
        end,
      },
    },
  }
end

return M
