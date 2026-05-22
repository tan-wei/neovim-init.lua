---@type LazyPluginSpec
local M = {
  "bngarren/checkmate.nvim",
  ft = "markdown",
}

M.opts = {
  files = {
    "todo.md",
  },
}

return M
