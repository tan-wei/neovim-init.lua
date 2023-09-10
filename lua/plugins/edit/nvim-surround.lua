local M = {
  "kylechui/nvim-surround",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
}

M.init = function()
  -- disable netrw at the very start of our init.lua
  vim.g.loaded_netrw = 1
  vim.g.loaded_netrwPlugin = 1
end

return M
