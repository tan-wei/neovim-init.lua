---@type LazyPluginSpec
local M = {
  "WhoIsSethDaniel/mason-tool-installer.nvim",
}

M.config = function()
  if vim.g.bootstrap_skip_mason_automatic_install then
    return
  end

  require("mason-tool-installer").setup {
    ensure_installed = require("user.mason_packages").tools,
    auto_update = true,
    start_delay = 3000,
    debounce_hours = 5,
  }
end

return M
