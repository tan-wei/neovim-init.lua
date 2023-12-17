local M = {
  "folke/trouble.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  cmd = { "Trouble", "TroubleClose", "TroubleToggle", "TroubleRefresh" },
}

-- TODO: This plugin should write more configurations
M.config = true

return M
