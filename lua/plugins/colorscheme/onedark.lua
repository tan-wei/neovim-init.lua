local M = {
  "joshdick/onedark.vim",
}

M.init = function()
  vim.g.onedark_termcolors = 256

  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "onedark")
  vim.g.available_colorschemes = available_colorschemes
end

return M
