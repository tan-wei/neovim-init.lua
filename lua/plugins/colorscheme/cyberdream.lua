local M = {
  "scottmckendry/cyberdream.nvim",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "cyberdream")
  vim.g.available_colorschemes = available_colorschemes
end

return M
