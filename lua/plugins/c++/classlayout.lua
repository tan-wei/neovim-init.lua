local M = {
  "J-Cowsert/classlayout.nvim",
  ft = { "c", "cpp" },
  cmd = {
    "ClassLayout",
  },
}

M.opts = {
  compiler = "clang",
  compile_commands = true,
}

return M
