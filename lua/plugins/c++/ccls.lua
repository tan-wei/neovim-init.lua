local M = {
  "ranjithshegde/ccls.nvim",
  enabled = false,
}

M.config = function()
  require("ccls").setup {
    lsp = {
      disable_capabilities = {
        completionProvider = true,
        documentFormattingProvider = true,
        documentRangeFormattingProvider = true,
        documentHighlightProvider = true,
        documentSymbolProvider = true,
        workspaceSymbolProvider = true,
        renameProvider = true,
        hoverProvider = true,
        codeActionProvider = true,
      },
      disable_diagnostics = true,
      disable_signature = true,
      codelens = { enable = true },
    },
  }
end

return M
