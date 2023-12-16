local M = {
  "petertriho/nvim-scrollbar",
  dependencies = {
    "lewis6991/gitsigns.nvim",
    "kevinhwang91/nvim-hlslens",
  },
  enabled = false,
}

M.config = function()
  local scrollbar = require "scrollbar"
  scrollbar.setup()
  require("scrollbar.handlers.gitsigns").setup()
  require("scrollbar.handlers.search").setup()
end

return M
