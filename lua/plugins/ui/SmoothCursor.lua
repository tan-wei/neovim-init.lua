local M = {
  "gen740/SmoothCursor.nvim",
  event = "VeryLazy",
}

M.config = function()
  require("smoothcursor").setup()
end

return M
