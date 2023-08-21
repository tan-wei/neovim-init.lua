local M = {
  "kvrohit/substrata.nvim",
}

M.init = function()
  vim.g.onedark_termcolors = 256

  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "substrata")
  vim.g.available_colorschemes = available_colorschemes
end

return M
