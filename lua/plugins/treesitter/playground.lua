local M = {
  "nvim-treesitter/playground",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  build = ":TSInstall query",
}

M.init = function() end

return M
