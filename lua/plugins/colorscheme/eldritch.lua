local M = {
  "eldritch-theme/eldritch.nvim",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "eldritch")
  vim.g.available_colorschemes = available_colorschemes
end

M.opts = {}

return M
