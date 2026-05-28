---@type LazyPluginSpec
local M = {
  "mason-org/mason.nvim",
  dependencies = {
    "mason-org/mason-lspconfig.nvim",
  },
  lazy = false,
}

M.config = function()
  local skip_automatic_install = vim.g.bootstrap_skip_mason_automatic_install
  local ensure_installed_servers = require("user.mason_packages").lsp_servers

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
    registry_cache = {
      refresh = not skip_automatic_install,
    },
  }

  require("mason").setup(settings)

  if skip_automatic_install then
    return
  end

  require("mason-lspconfig").setup {
    ensure_installed = ensure_installed_servers,
    automatic_installation = true,
    automatic_enable = {},
  }
end

return M
