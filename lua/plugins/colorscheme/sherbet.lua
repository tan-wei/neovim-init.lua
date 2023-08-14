local M = {
  "lewpoly/sherbet.nvim",
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "sherbet")
  vim.g.available_colorschemes = available_colorschemes
end

return M
