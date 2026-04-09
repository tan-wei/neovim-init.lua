local noopfn = function() end

return {
  -- Disable capabilities that conflict with clangd
  -- (mirrors what ccls.nvim's disable_capabilities did in on_init)
  on_init = function(client)
    local sc = client.server_capabilities
    sc.completionProvider = false
    sc.documentFormattingProvider = false
    sc.documentRangeFormattingProvider = false
    sc.documentHighlightProvider = false
    sc.documentSymbolProvider = false
    sc.workspaceSymbolProvider = false
    sc.renameProvider = false
    sc.hoverProvider = false
    sc.codeActionProvider = false
  end,
  -- Suppress diagnostics and signature (mirrors ccls.nvim's nil_handlers)
  handlers = {
    ["textDocument/publishDiagnostics"] = noopfn,
    ["textDocument/signatureHelp"] = noopfn,
  },
  settings = {
    init_options = {
      compilationDatabaseDirectory = "build",
      index = {
        threads = 2,
      },
      cache = {
        directory = vim.fn.stdpath "cache" .. "/.ccls-cache",
      },
    },
  },
}
