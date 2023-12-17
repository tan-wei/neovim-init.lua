local M = {
  "kevinhwang91/nvim-hlslens",
  event = "VeryLazy",
}

-- TODO: This plugin should write more configurations
M.config = function()
  require("hlslens").setup()
end

return M
