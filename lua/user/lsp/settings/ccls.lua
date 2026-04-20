local noopfn = function() end

return {
  before_init = function(_, config)
    local ok, cmake = pcall(require, "cmake-tools")
    if ok then
      cmake.ccls_on_new_config(config)
      return
    end

    local root_dir = config.root_dir
    if not root_dir or root_dir == "" then
      return
    end

    if vim.uv.fs_stat(root_dir .. "/compile_commands.json") then
      config.init_options.compilationDatabaseDirectory = root_dir
      return
    end

    local build_dir = root_dir .. "/build"
    if vim.uv.fs_stat(build_dir .. "/compile_commands.json") then
      config.init_options.compilationDatabaseDirectory = build_dir
      return
    end

    config.init_options.compilationDatabaseDirectory = build_dir
  end,
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
  -- Suppress diagnostics, signature, and "not indexed" response errors from ccls.
  -- Wrap common request handlers to silently ignore -32600 ("not indexed") errors.
  handlers = (function()
    local function wrap_handler(method)
      return function(err, result, ctx, config)
        if err and err.code == -32600 then
          return -- silently ignore "not indexed"
        end
        -- Fall through to default handler
        return vim.lsp.handlers[method](err, result, ctx, config)
      end
    end
    return {
      ["textDocument/publishDiagnostics"] = noopfn,
      ["textDocument/signatureHelp"] = noopfn,
      ["textDocument/definition"] = wrap_handler "textDocument/definition",
      ["textDocument/references"] = wrap_handler "textDocument/references",
      ["textDocument/hover"] = wrap_handler "textDocument/hover",
      ["textDocument/implementation"] = wrap_handler "textDocument/implementation",
      ["textDocument/typeDefinition"] = wrap_handler "textDocument/typeDefinition",
      ["textDocument/documentSymbol"] = wrap_handler "textDocument/documentSymbol",
      ["textDocument/codeAction"] = wrap_handler "textDocument/codeAction",
      ["textDocument/codeLens"] = wrap_handler "textDocument/codeLens",
      ["callHierarchy/incomingCalls"] = wrap_handler "callHierarchy/incomingCalls",
      ["callHierarchy/outgoingCalls"] = wrap_handler "callHierarchy/outgoingCalls",
    }
  end)(),
  init_options = {
    index = {
      threads = 2,
    },
    cache = {
      directory = vim.fn.stdpath "cache" .. "/.ccls-cache",
    },
  },
}
