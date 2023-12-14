local M = {
  "NvChad/nvim-colorizer.lua",
  ft = "lua",
}

M.config = function()
  require("colorizer").setup {
    filetypes = { "lua" },
  }
end

return M
