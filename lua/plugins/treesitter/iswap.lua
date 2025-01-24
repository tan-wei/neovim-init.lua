local M = {
  "mizlan/iswap.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  event = "VeryLazy",
}

M.config = function()
  require("iswap").setup {
    flash_style = "simultaneous", -- 'sequential'
  }
end

return M
