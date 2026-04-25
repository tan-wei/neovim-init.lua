local M = {
  "marcos-venicius/zenburned",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "zenburned")
  vim.g.available_colorschemes = available_colorschemes
end

return M
