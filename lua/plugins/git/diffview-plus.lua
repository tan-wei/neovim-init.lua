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

-- TODO: This plugin should write more configurations
M.config = true

return M
