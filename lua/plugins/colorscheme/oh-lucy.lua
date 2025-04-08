local M = {
  "yazeed1s/oh-lucy.nvim",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "oh-lucy")
  vim.g.available_colorschemes = available_colorschemes
end

return M
