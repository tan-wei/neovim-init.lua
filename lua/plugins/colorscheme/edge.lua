local M = {
  "sainnhe/edge",
}

M.init = function()
  vim.g.edge_style = "aura"
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "edge")
  vim.g.available_colorschemes = available_colorschemes
end

return M
