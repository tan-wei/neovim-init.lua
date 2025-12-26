local M = {
  "1995parham/naz.vim",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "naz")
  vim.g.available_colorschemes = available_colorschemes
end

return M
