local M = {
  "NTBBloodbath/doom-one.nvim",
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "doom-one")
  vim.g.available_colorschemes = available_colorschemes
end

return M
