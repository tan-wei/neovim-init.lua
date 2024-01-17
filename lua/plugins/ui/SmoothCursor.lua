local M = {
  "gen740/SmoothCursor.nvim",
  event = "VeryLazy",
}

M.config = function()
  require("smoothcursor").setup {
    disabled_filetypes = {
      "lazy",
    },
  }
end

return M
