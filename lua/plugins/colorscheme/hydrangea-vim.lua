local M = {
  "yuttie/hydrangea-vim",
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "hydrangea")
  vim.g.available_colorschemes = available_colorschemes
end

return M
