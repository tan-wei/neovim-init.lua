local M = {
  "gen740/SmoothCursor.nvim",
  event = "VeryLazy",
}

M.config = function()
  require("smoothcursor").setup {
    fancy = {
      enable = true,
    },
    disabled_filetypes = {
      "lazy",
      "NvimTree",
    },
    disable_float_win = true,
  }
end

return M
