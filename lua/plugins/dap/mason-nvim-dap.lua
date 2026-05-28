---@type LazyPluginSpec
local M = {
  "jay-babu/mason-nvim-dap.nvim",
  dependencies = {
    "mason-org/mason.nvim",
  },
}

-- TODO: This plugin should write more configurations
M.config = function()
  if vim.g.bootstrap_skip_mason_automatic_install then
    return
  end

  require("mason-nvim-dap").setup {
    ensure_installed = require("user.mason_packages").dap_adapters,
  }
end

return M
