local M = {
  "sharpchen/Eva-Theme.nvim",
  lazy = true,
  build = ":EvaCompile",
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "Eva-Dark")
  table.insert(available_colorschemes, "Eva-Dark-Bold")
  table.insert(available_colorschemes, "Eva-Dark-Italic")
  table.insert(available_colorschemes, "Eva-Dark-Italic-Bold")
  vim.g.available_colorschemes = available_colorschemes
end

M.config = true

return M
