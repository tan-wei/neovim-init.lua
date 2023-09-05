local M = {
  "embark-theme/vim",
  name = "embark",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "embark")
  vim.g.available_colorschemes = available_colorschemes
end

return M
