local M = {
  "esmuellert/codediff.nvim",
  dependencies = {
    "MunifTanjim/nui.nvim",
  },
  cmd = {
    "CodeDiff",
  },
  build = "CodeDiff install",
}

-- TODO: This plugin should write more configurations
M.config = true

return M
