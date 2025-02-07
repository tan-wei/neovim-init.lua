local M = {
  "Thiago4532/mdmath.nvim",
  enabled = require("util.os").is_linux() or require("util.os").is_macos(),
  -- cond = require("util.client").is_kitty(),
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  ft = { "markdown" },
  cmd = { "MdMath" },
}

M.opts = {}

return M
