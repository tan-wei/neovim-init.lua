local M = {
  "luisiacc/gruvbox-baby",
  lazy = true,
}

M.init = function()
  vim.g.background_color = "dark"
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "gruvbox-baby")
  vim.g.available_colorschemes = available_colorschemes
end

return M
