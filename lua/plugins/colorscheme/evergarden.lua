local M = {
  "crispybaccoon/evergarden",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "evergarden")
  vim.g.available_colorschemes = available_colorschemes
end

return M
