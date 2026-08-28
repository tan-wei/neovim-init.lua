---@type LazyPluginSpec
local M = {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "antoinemadec/FixCursorHold.nvim",
    "stevearc/overseer.nvim",
    "vim-test/vim-test",
    "nvim-neotest/neotest-vim-test",
    "rouge8/neotest-rust",
    "nvim-neotest/nvim-nio",
    "orjangj/neotest-ctest",
  },
  event = "VeryLazy",
}

local ctest_source_extensions = {
  c = true,
  cc = true,
  cpp = true,
  cxx = true,
  ["c++"] = true,
}

local ctest_test_file_patterns = {
  path = { "^test/", "^tests/", "/test/", "/tests/" },
  stem = { "^test_", "^tests_", "_test$", "_tests$", "^s%d%d%d%d_" },
}

local function matches_any_pattern(text, patterns)
  for _, pattern in ipairs(patterns) do
    if text:match(pattern) then
      return true
    end
  end

  return false
end

local function parse_ctest_file(file)
  local normalized = vim.fs.normalize(file):lower()
  local basename = vim.fs.basename(normalized)
  local stem, extension = basename:match "^(.*)%.([^.]+)$"

  return normalized, stem, extension
end

local function is_ctest_test_file(file)
  local normalized, stem, extension = parse_ctest_file(file)

  if extension == nil or ctest_source_extensions[extension] ~= true then
    return false
  end

  return matches_any_pattern(normalized, ctest_test_file_patterns.path)
    or matches_any_pattern(stem, ctest_test_file_patterns.stem)
end

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
    consumers = {
      overseer = require "neotest.consumers.overseer",
    },
    adapters = {
      require "neotest-rust" { allow_file_types = { "rust" } },
      require("neotest-ctest").setup {
        is_test_file = is_ctest_test_file,
      },
    },
  }
end

return M
