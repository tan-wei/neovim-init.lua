---@type LazyPluginSpec
local M = {
  "elanmed/fzf-lua-frecency.nvim",
  dependencies = {
    "ibhagwan/fzf-lua",
  },
  event = "VeryLazy",
}

M.config = function()
  require("fzf-lua-frecency").setup()
end

return M
