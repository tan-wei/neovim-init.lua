---@type LazyPluginSpec
local M = {
  "julienvincent/hunk.nvim",
  cmd = { "HunkDiffEditor", "HunkDiffView" },
  dependencies = { "MunifTanjim/nui.nvim", "nvim-tree/nvim-web-devicons" },
}

M.opts = {
  ui = {
    tree = { mode = "compact" },
    confirm_before_quit = true,
  },
}

return M
