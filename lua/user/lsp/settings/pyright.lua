---@type vim.lsp.Config
local M = {
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = "openFilesOnly",
        useLibraryCodeForTypes = true,
      },
    },
    single_file_support = true,
  },
}

return M
