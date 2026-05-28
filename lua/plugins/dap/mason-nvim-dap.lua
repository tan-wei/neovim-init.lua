---@type LazyPluginSpec
local M = {
  "jay-babu/mason-nvim-dap.nvim",
  dependencies = {
    "mason-org/mason.nvim",
  },
}

-- TODO: This plugin should write more configurations
M.config = function()
  require("mason-nvim-dap").setup {
    ensure_installed = require("user.mason_packages").dap_adapters,
  }
end

return M
