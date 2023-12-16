local M = {
  "akinsho/git-conflict.nvim",
  cmd = {
    "GitConflictChooseOurs",
    "GitConflictChooseTheirs",
    "GitConflictChooseBoth",
    "GitConflictChooseNone",
    "GitConflictNextConflict",
    "GitConflictPrevConflict",
    "GitConflictListQf",
  },
}

-- TODO: This plugin should write more configurations
M.config = true

return M
