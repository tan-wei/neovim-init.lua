local M = {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
  },
  event = "VeryLazy",
}

M.config = function()
  local servers = {
    "lua_ls",
    -- "cssls",
    -- "html",
    -- "tsserver",
    "pyright",
    -- "bashls",
    "jsonls",
    -- "yamlls",
    "clangd",
    -- "ccls",
    "ltex",
    -- "rust_analyzer", -- rust-tools.nvim automatically sets up nvim-lspconfig for rust_analyzer
    "marksman",
    "cmake",
  }

  local ensure_installed_servers = {
    "lua_ls",
    -- "cssls",
    -- "html",
    -- "tsserver",
    "pyright",
    -- "bashls",
    "jsonls",
    -- "yamlls",
    "clangd",
    "rust_analyzer",
    "marksman",
    "cmake",
    "ltex",
  }

  local settings = {
    ui = {
      border = "none",
      icons = {
        package_installed = "◍",
        package_pending = "◍",
        package_uninstalled = "◍",
      },
    },
    log_level = vim.log.levels.INFO,
    max_concurrent_installers = 4,
  }

  require("mason").setup(settings)
  require("mason-lspconfig").setup {
    ensure_installed = ensure_installed_servers,
    automatic_installation = true,
  }

  local lspconfig = require "lspconfig"

  local opts = {}

  for _, server in pairs(servers) do
    opts = {
      on_attach = require("user.lsp.handlers").on_attach,
      capabilities = require("user.lsp.handlers").capabilities,
    }

    server = vim.split(server, "@")[1]

    local require_ok, conf_opts = pcall(require, "user.lsp.settings." .. server)
    if require_ok then
      opts = vim.tbl_deep_extend("force", conf_opts, opts)
    end
    lspconfig[server].setup(opts)
  end
end

return M
