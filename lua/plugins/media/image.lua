local M = {
  "3rd/image.nvim",
  enabled = require("util.os").is_linux() or require("util.os").is_macos(),
  -- cond = require("util.client").is_kitty(),
  rocks = {
    hererocks = true,
  },
}

M.opts = {}

return M
