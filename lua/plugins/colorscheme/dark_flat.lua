local M = {
  "sekke276/dark_flat.nvim",
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "dark_flat")
  vim.g.available_colorschemes = available_colorschemes
end

return M
