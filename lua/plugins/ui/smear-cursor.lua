local M = {
  "sphamba/smear-cursor.nvim",
  event = "VeryLazy",
  cond = require("util.client").is_cui_client() and not require("util.client").is_kitty(),
}

M.opts = {
  smear_between_buffers = true,
  smear_between_neighbor_lines = true,
  scroll_buffer_space = true,
  legacy_computing_symbols_support = false,
}

return M
