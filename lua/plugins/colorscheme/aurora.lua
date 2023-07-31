local M = {
  "ray-x/aurora",
}

M.init = function()
  vim.g.aurora_italic = 1
  vim.g.aurora_transparent = 1
  vim.g.aurora_bold = 1
  vim.g.aurora_darker = 1
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "aurora")
  vim.g.available_colorschemes = available_colorschemes
end

return M
