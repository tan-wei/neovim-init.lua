local M = {
  "kihachi2000/yash.nvim",
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "yash")
  vim.g.available_colorschemes = available_colorschemes
end

return M
