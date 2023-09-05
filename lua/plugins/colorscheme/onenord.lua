local M = {
  "rmehri01/onenord.nvim",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "onenord")
  vim.g.available_colorschemes = available_colorschemes
end

return M
