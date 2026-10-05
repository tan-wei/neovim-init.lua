---@type LazyPluginSpec
local M = {
  "esmuellert/codediff.nvim",
  dependencies = {
    "MunifTanjim/nui.nvim",
  },
  cmd = {
    "CodeDiff",
  },
  build = ":CodeDiff install",
}

M.config = true

return M
