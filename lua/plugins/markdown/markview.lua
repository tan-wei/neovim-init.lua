local M = {
  "OXY2DEV/markview.nvim",
  lazy = false, -- NOTE: Do not lazy load because it is already lazy-loaded
  branch = "dev",
}

M.opts = {
  preview = {
    enable = false,
  },
}

return M
