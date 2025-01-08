return {
  root_dir = root_dir or util.path.dirname,
  init_options = {
    compilationDatabaseDirectory = "build",
    index = {
      threads = 2,
    },
    cache = {
      directory = vim.fn.stdpath "cache" .. "/.ccls-cache",
    },
  },
}
