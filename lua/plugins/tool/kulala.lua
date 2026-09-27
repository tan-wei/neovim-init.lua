---@type LazyPluginSpec
local M = {
  "dont-be-evil-company/kulala.nvim",
  dependencies = {
    "MunifTanjim/nui.nvim",
  },
  ft = { "http", "rest" },
  enabled = false, -- The repo is deleted with unknown reason
}

-- TODO: This plugin should write more configurations, keymaps should be added
M.config = true

return M
