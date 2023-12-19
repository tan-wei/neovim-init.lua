local M = {
  "ellisonleao/dotenv.nvim",
  event = { "VimEnter" },
}

M.config = function()
  require("dotenv").setup {
    enable_on_load = true,
    verbose = false,
  }
end

return M
