---@type LazyPluginSpec
local M = {
  "retran/meow.yarn.nvim",
  dependencies = { "MunifTanjim/nui.nvim" },
  cmd = "MeowYarn",
}

M.config = function()
  require("meow.yarn").setup()
end

return M
