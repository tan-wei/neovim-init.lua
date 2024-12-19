local util = require "lspconfig.util"

local root_dir =
  vim.fs.dirname(vim.fs.find({ "compile_commands.json", "compile_flags.txt", ".git" }, { upward = true })[1])

local cache_directory = nil

if root_dir then
  if type(root_dir) == "function" then
    if not root_dir() then
      cache_directory = vim.fs.normalize(root_dir() .. "/.nvim/.ccls-cache")
    end
  else
    cache_directory = vim.fs.normalize(root_dir .. "/.nvim/.ccls-cache")
  end
end

return {
  root_dir = root_dir or util.path.dirname,
  init_options = {
    compilationDatabaseDirectory = "build",
    index = {
      threads = 2,
    },
    cache = {
      directory = cache_directory,
    },
  },
}
