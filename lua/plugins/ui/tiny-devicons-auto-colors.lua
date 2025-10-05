local M = {
  "rachartier/tiny-devicons-auto-colors.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  event = "VeryLazy",
}

M.config = function()
  require("tiny-devicons-auto-colors").setup()
end

return M
