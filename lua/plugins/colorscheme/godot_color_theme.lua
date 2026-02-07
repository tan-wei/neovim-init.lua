local M = {
  "voylin/godot_color_theme",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "godot")
  vim.g.available_colorschemes = available_colorschemes
end

return M
