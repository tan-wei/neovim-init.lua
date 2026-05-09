local M = {
  "3rd/image.nvim",
  enabled = require("util.package").enabled_unix_only(),
  cond = require("util.provider").image_protocol_support(),
  lazy = true,
}

M.opts = {}

return M
