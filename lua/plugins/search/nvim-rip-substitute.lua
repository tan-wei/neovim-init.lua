---@type LazyPluginSpec
local M = {
  "chrisgrieser/nvim-rip-substitute",
  cmd = "RipSubstitute",
}

M.config = function()
  require("rip-substitute").setup()
end

return M
