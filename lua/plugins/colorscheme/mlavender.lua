local M = {
  "MarkChuCarroll/mlavender",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "mlavender")
  vim.g.available_colorschemes = available_colorschemes
end

return M
