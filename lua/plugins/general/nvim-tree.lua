local M = {
  "nvim-tree/nvim-tree.lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
}

M.init = function()
  -- disable netrw at the very start of our init.lua
  vim.g.loaded_netrw = 1
  vim.g.loaded_netrwPlugin = 1
end

return M
