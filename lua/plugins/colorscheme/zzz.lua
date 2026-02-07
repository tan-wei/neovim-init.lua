local M = {
  "r1cardohj/zzz.vim",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "zzz")
  vim.g.available_colorschemes = available_colorschemes
end

return M
