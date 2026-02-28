local M = {
  "ikelaiah/nebula-drift-omega",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "nebula-drift-omega")
  vim.g.available_colorschemes = available_colorschemes
end

return M
