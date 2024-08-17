local M = {
  "p00f/clangd_extensions.nvim",
  ft = { "c", "cpp" },
  cmd = {
    "ClangdSwitchSourceHeader",
    "ClangdSetInlayHints",
    "ClangdDisableInlayHints",
    -- "ClangdToggleInlayHints", -- Seems not useful now
    "ClangdAST",
    "ClangdSymbolInfo",
    "ClangdTypeHierarchy",
    "ClangdMemoryUsage",
  },
}

-- NOTE: Default option is OK
M.opts = true

return M
