
local M = {
  "frenzyexists/aquarium-vim",
}

M.init = function()
  vim.g.aquarium_style = "dark"
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "aquarium")
  vim.g.available_colorschemes = available_colorschemes
end

return M
