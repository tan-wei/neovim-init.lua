local M = {
  "t-troebst/perfanno.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-telescope/telescope.nvim",
  },
  enabled = require("util.package").enabled_unix_only(),
  cmd = { "PerfAnnotateFunction", "PerfHottestCallersFunction" },
}

-- TODO: This plugin should write more configurations
M.config = true

return M
