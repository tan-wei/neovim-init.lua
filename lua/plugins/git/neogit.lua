---@type LazyPluginSpec
local M = {
  "NeogitOrg/neogit",
  dependencies = {
    "sindrets/diffview.nvim",
    "ibhagwan/fzf-lua",
  },
  cmd = { "Neogit", "NeogitLog", "NeogitCommit" },
}

M.opts = {
  graph_style = "unicode",
  kind = "floating",
}

return M
