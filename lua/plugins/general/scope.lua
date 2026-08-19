---@type LazyPluginSpec
local M = {
  "tiagovla/scope.nvim",
  cmd = { "ScopeLoadState", "ScopeSaveState" },
}

M.config = function()
  require("scope").setup()
end

return M
