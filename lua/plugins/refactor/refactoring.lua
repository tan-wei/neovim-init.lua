---@type LazyPluginSpec
local M = {
  "ThePrimeagen/refactoring.nvim",
  cmd = "Refactor",
}

M.config = function()
  require("refactoring").setup()
end

return M
