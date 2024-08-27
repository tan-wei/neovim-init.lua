local M = {
  "loctvl842/monokai-pro.nvim",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "monokai-pro")
  vim.g.available_colorschemes = available_colorschemes
end

M.config = function()
  require("monokai-pro").setup()
end

return M
