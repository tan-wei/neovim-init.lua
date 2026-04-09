local M = {
  "neovim/nvim-lspconfig",
  dependencies = {
    {
      "hrsh7th/cmp-nvim-lsp",
      cond = function()
        return vim.g.completion_engine ~= "blink"
      end,
    },
    {
      "saghen/blink.cmp",
      cond = function()
        return vim.g.completion_engine == "blink"
      end,
    },
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
  -- "cmake",
  "neocmake",
  "solargraph",
  "tombi",
  "jq-lsp",
  "just",
}

M.config = function()
  local handlers = require "user.lsp.handlers"
  handlers.setup()

  for _, server in pairs(servers) do
    local opts = {
      on_attach = handlers.on_attach,
      capabilities = handlers.capabilities,
    }

    server = vim.split(server, "@")[1]

    local require_ok, conf_opts = pcall(require, "user.lsp.settings." .. server)
    if require_ok then
      opts = vim.tbl_deep_extend("force", conf_opts, opts)
    else
      vim.notify("Server [" .. server .. "] is not available")
    end

    vim.lsp.config(server, opts)
    vim.lsp.enable(server)
  end
end

return M
