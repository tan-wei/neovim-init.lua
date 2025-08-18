local M = {
  "stevearc/oil.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  lazy = false,
}

M.init = function()
  -- disable netrw at the very start of our init.lua
  vim.g.loaded_netrw = 1
  vim.g.loaded_netrwPlugin = 1
end

M.opts = {
  default_file_explorer = false,
  columns = {
    "icon",
    -- "permissions",
    -- "size",
    -- "mtime",
  },
}

return M
