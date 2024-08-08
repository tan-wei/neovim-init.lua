local M = {
  "neovim/nvim-lspconfig",
  dependencies = {
    {
      "antosha417/nvim-lsp-file-operations",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-tree.lua",
      },
      config = true,
    },
    { "hrsh7th/cmp-nvim-lsp" },
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
  -- "ccls",
  "ltex",
  -- "rust_analyzer", -- rust-tools.nvim automatically sets up nvim-lspconfig for rust_analyzer
  "marksman",
  "cmake",
  "solargraph",
}

M.config = function()
  local lspconfig = require "lspconfig"

  -- FIXME: Lazy load lspconfig will cause buffers are not attached, please see: https://github.com/wookayin/dotfiles/blob/e2fe550ec3e29584992c20d732b32144dc6a3fd9/nvim/lua/config/lsp.lua#L438

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
    lspconfig[server].setup(opts)
  end
end

return M
