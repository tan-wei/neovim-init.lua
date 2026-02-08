local M = {
  "sugiura-hiromiti/newt.nvim",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "newt")
  vim.g.available_colorschemes = available_colorschemes
end

M.config = function()
  require("newt").setup()
end

return M
