local M = {
  "casonadams/walh",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "walh-default")
  table.insert(available_colorschemes, "walh-blue")
  table.insert(available_colorschemes, "walh-darcula")
  table.insert(available_colorschemes, "walh-gruvbox")
  table.insert(available_colorschemes, "walh-nord")
  table.insert(available_colorschemes, "walh-one")
  table.insert(available_colorschemes, "walh-solarized")
  table.insert(available_colorschemes, "walh-blue")
  vim.g.available_colorschemes = available_colorschemes
end

return M
