---@type LazyPluginSpec
local M = {
  "t-troebst/perfanno.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "ibhagwan/fzf-lua",
  },
  enabled = require("util.package").enabled_unix_only(),
  cmd = { "PerfAnnotateFunction", "PerfHottestCallersFunction" },
}

M.config = true

return M
