local M = {
  "sphamba/smear-cursor.nvim", -- Fork to fix #38
  event = "VeryLazy",
  cond = require("util.client").is_cui_client,
}

M.opts = {
  smear_between_buffers = true,
  smear_between_neighbor_lines = true,
  scroll_buffer_space = true,
  legacy_computing_symbols_support = false,
}

return M
