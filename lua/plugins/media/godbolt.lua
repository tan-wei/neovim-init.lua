local M = {
  "p00f/godbolt.nvim",
  cmd = { "Godbolt", "GodboltCompiler" },
}

M.opts = {
  languages = {
    cpp = { compiler = "clang1700", options = {} },
    c = { compiler = "clang1700", options = {} },
    rust = { compiler = "nightly", options = {} },
  },
  quickfix = {
    enable = true,
    auto_open = true,
  },
  url = "https://godbolt.org", -- can be changed to a different godbolt instance
}

return M
