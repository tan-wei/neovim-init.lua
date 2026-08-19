---@type LazyPluginSpec
local M = {
  "elanmed/fzf-lua-frecency.nvim",
  enabled = require("util.package").enabled_unix_only(),
  dependencies = {
    "ibhagwan/fzf-lua",
  },
  event = "VeryLazy",
}

M.config = function()
  require("fzf-lua-frecency").setup()
end

return M
