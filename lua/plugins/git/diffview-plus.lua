---@type LazyPluginSpec
local M = {
  "dlyongemallo/diffview-plus.nvim", -- NOTE: Use fork version which is actively maintained
  cmd = {
    "DiffviewOpen",
    "DiffviewFileHistory",
    "DiffviewClose",
    "DiffviewToggleFiles",
    "DiffviewFocusFiles",
    "DiffviewRefresh",
    "DiffviewLog",
  },
}

M.config = true

return M
