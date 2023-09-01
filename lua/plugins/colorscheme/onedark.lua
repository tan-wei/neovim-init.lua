local M = {
  "navarasu/onedark.nvim",
}

M.init = function()
  vim.g.onedark_config = {
    style = "warmer",
  }
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "onedark")
  vim.g.available_colorschemes = available_colorschemes
end

return M
