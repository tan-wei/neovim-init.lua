local M = {
  "muchzill4/doubletrouble",
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "doubletrouble")
  vim.g.available_colorschemes = available_colorschemes
end

return M
