local M = {
  "rachartier/tiny-glimmer.nvim",
  event = "VeryLazy",
}

M.config = function()
  require("tiny-glimmer").setup {
    disable_warnings = true,
    default_animation = "pulse",
  }
end

return M
