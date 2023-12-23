local M = {
  "NvChad/nvim-colorizer.lua",
  event = "VeryLazy",
}

M.config = function()
  require("colorizer").setup {
    filetypes = { "lua" },
  }
end

return M
