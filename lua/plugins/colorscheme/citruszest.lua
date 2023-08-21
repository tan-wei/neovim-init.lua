local M = {
  "zootedb0t/citruszest.nvim",
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "citruszest")
  vim.g.available_colorschemes = available_colorschemes
end

return M
