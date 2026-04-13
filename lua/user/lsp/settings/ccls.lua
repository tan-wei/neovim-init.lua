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
  -- Suppress diagnostics and signature (mirrors ccls.nvim's nil_handlers)
  handlers = {
    ["textDocument/publishDiagnostics"] = noopfn,
    ["textDocument/signatureHelp"] = noopfn,
  },
  init_options = {
    index = {
      threads = 2,
    },
    cache = {
      directory = vim.fn.stdpath "cache" .. "/.ccls-cache",
    },
  },
}
