local M = {
  "AstroNvim/astrotheme",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "astrodark")
  table.insert(available_colorschemes, "astromars")
  vim.g.available_colorschemes = available_colorschemes
end

M.config = true

return M
