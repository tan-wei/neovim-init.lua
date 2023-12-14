local M = {
  "folke/zen-mode.nvim",
  dependencies = {
    "folke/twilight.nvim",
  },
  cmd = "ZenMode",
}

-- TODO: This plugin should write more configurations, especially for wezterm, kitty
M.config = function()
  require("zen-mode").setup()
end

return M
