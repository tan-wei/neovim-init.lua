---@type LazyPluginSpec
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

M.config = function(_, opts)
  require("smear_cursor").setup(opts)
  -- DAP terminal creation can trigger ModeChanged while opening a window is forbidden (E565).
  vim.api.nvim_clear_autocmds { group = "SmearCursor", event = "ModeChanged" }
  vim.api.nvim_create_autocmd("ModeChanged", {
    group = "SmearCursor",
    callback = vim.schedule_wrap(require("smear_cursor.events").move_cursor),
  })
end

return M
