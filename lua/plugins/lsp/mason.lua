local M = {
  "mason-org/mason.nvim",
  dependencies = {
    "mason-org/mason-lspconfig.nvim",
  },
  lazy = false,
}

M.config = function()
  local ensure_installed_servers = {
    -- "bashls",
    "clangd",
    -- "cmake",
    -- "cssls",
    -- "html",
    "jsonls",
    "ltex_plus",
    "lua_ls",
    "marksman",
    "neocmake",
    "pyright",
    "rust_analyzer",
    "solargraph",
    "tombi",
    -- "tsserver",
    "yamlls",
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
