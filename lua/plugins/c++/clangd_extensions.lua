local M = {
  "https://git.sr.ht/~chinmay/clangd_extensions.nvim",
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
