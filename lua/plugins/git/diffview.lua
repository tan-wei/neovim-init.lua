local M = {
  "dlyongemallo/diffview.nvim", -- NOTE: Use fork version which is actively maintained
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
