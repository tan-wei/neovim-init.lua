---@type LazyPluginSpec
local M = {
  "abccsss/nvim-gitstatus",
  event = "VeryLazy",
}

M.opts = {
  auto_fetch_interval = 30000,
  git_status_timeout = 1500,
  debug = false,
}

return M
