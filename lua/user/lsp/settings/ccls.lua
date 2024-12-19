local util = require "lspconfig.util"

local root_dir =
  vim.fs.dirname(vim.fs.find({ "compile_commands.json", "compile_flags.txt", ".git" }, { upward = true })[1])

return {
  root_dir = root_dir or util.path.dirname,
  init_options = {
    compilationDatabaseDirectory = "build",
    index = {
      threads = 2,
    },
    cache = {
      directory = vim.fs.normalize(root_dir .. "/.nvim/.ccls-cache"),
    },
  },
}
