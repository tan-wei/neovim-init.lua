local M = {
  "mhartington/oceanic-next",
  lazy = true,
}

M.init = function()
  vim.g.oceanic_next_terminal_bold = 1
  vim.g.oceanic_next_terminal_italic = 1
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "OceanicNext")
  vim.g.available_colorschemes = available_colorschemes
end

return M
