local M = {
  "loganswartz/sunburn.nvim",
  dependencies = {
    "loganswartz/polychrome.nvim",
  },
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "sunburn")
  vim.g.available_colorschemes = available_colorschemes
end

return M
