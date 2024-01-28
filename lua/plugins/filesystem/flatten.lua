local M = {
  "willothy/flatten.nvim",
  lazy = false,
  priority = 1001,
}

M.config = function()
  require("flatten").setup {
    one_per = {
      kitty = require("util.client").is_kitty(),
      wezterm = require("util.client").is_wezterm(),
    },
  }
end

M.opts = {}

return M
