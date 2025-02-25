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
    "orjangj/neotest-ctest",
  },
  event = "VeryLazy",
}

M.config = function()
  local neotest_ns = vim.api.nvim_create_namespace "neotest"
  vim.diagnostic.config({
    virtual_text = {
      format = function(diagnostic)
        -- Convert newlines, tabs and whitespaces into a single whitespace
        -- for improved virtual text readability
        local message = diagnostic.message:gsub("[\r\n\t%s]+", " ")
        return message
      end,
    },
  }, neotest_ns)

  require("neotest").setup {
    adapters = {
      require "neotest-rust" { allow_file_types = { "rust" } },
      require("neotest-ctest").setup {
        is_test_file = function(file)
          -- File name begins or ends with test[s]
          return string.find(file, "[tT][eE][sS][tT][sS]?_") ~= nil
            or string.find(file, "_[tT][eE][sS][tT][sS]?") ~= nil
        end,
      },
    },
  }
end

return M
