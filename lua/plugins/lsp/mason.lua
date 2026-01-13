local M = {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
  },
  lazy = false,
}

M.config = function()
  local ensure_installed_servers = {
    "lua_ls",
    -- "cssls",
    -- "html",
    -- "tsserver",
    "pyright",
    -- "bashls",
    "jsonls",
    "yamlls",
    "clangd",
    "rust_analyzer",
    "marksman",
    -- "cmake",
    "neocmake",
    "ltex_plus",
    "solargraph",
    "tombi",
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
    automatic_enable = {},
  }
end

return M
