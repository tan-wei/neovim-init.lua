local M = {
  "neovim/nvim-lspconfig",
  dependencies = {
    { "hrsh7th/cmp-nvim-lsp" },
    -- { "ranjithshegde/ccls.nvim" }, -- FIXME: Trewaky now
  },
  event = { "BufReadPre", "BufNewFile" },
}

local servers = {
  "lua_ls",
  -- "cssls",
  -- "html",
  -- "tsserver",
  "pyright",
  -- "bashls",
  "jsonls",
  "yamlls",
  "clangd",
  "ccls",
  "ltex_plus",
  -- "rust_analyzer", -- rust-tools.nvim automatically sets up nvim-lspconfig for rust_analyzer
  "marksman",
  "cmake",
  "solargraph",
}

M.config = function()
  for _, server in pairs(servers) do
    local opts = {
      on_attach = require("user.lsp.handlers").on_attach,
      capabilities = require("user.lsp.handlers").capabilities,
    }

    server = vim.split(server, "@")[1]

    local require_ok, conf_opts = pcall(require, "user.lsp.settings." .. server)
    if require_ok then
      opts = vim.tbl_deep_extend("force", conf_opts, opts)
    else
      vim.notify("Server [" .. server .. "] is not available")
    end

    -- FIXME: Tricky now
    if server == "ccls" then
      -- vim.print(opts)

      -- require("ccls").setup {
      --   lsp = {
      --     lspconfig = opts,
      --     disable_capabilities = {
      --       completionProvider = true,
      --       documentFormattingProvider = true,
      --       documentRangeFormattingProvider = true,
      --       documentHighlightProvider = true,
      --       documentSymbolProvider = true,
      --       workspaceSymbolProvider = true,
      --       renameProvider = true,
      --       hoverProvider = true,
      --       codeActionProvider = true,
      --     },
      --     disable_diagnostics = true,
      --     disable_signature = true,
      --     codelens = { enable = true },
      --   },
      -- }
    else
      vim.lsp.config(server, opts)
      vim.lsp.enable(server)
    end
  end
end

return M
