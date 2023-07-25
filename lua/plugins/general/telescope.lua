local M = {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
    "nvim-lua/plenary.nvim",
  },
}

M.init = function()
  vim.g.barbar_auto_setup = false
end

return M
