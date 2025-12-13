local M = {
  "ricardoraposo/nightwolf.nvim",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "nightwolf-black")
  table.insert(available_colorschemes, "nightwolf-gray")
  table.insert(available_colorschemes, "nightwolf-dark-gray")
  table.insert(available_colorschemes, "nightwolf-dark-blue")
  vim.g.available_colorschemes = available_colorschemes
end

M.config = true

return M
