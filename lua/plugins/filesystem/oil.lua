local M = {
  "stevearc/oil.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  cmd = { "Oil" },
}

M.init = function()
  -- disable netrw at the very start of our init.lua
  vim.g.loaded_netrw = 1
  vim.g.loaded_netrwPlugin = 1
end

M.opts = {}

return M
