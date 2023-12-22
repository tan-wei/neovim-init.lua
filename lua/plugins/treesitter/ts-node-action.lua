local M = {
  "ckolkey/ts-node-action",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  event = "VeryLazy",
}

-- TODO: Configure for ts-node-action
M.opts = {}

return M
