local M = {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
}

M.opts = {
  bigfile = {
    enabled = true,
    notify = true,
    size = 1.5 * 1024 * 1024,
    line_length = 10000,
  },
}

return M
