local lspconfig = require "lspconfig"

return {
  init_options = {
    compilationDatabaseDirectory = "build",
    index = {
      threads = 2,
    },
    cache = {
      directory = ".vscode/.ccls-cache",
    },
  },
}
