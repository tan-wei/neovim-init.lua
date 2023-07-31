local M = {
  "srcery-colors/srcery-vim",
}

M.init = function()
  vim.g.srcery_italic = 1
  vim.g.srcery_bold = 1
  vim.g.srcery_underline = 1
  vim.g.srcery_undercurl = 1
  vim.g.srcery_inverse = 1
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "srcery")
  vim.g.available_colorschemes = available_colorschemes
end

return M
