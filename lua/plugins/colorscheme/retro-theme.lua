local M = {
  "mistweaverco/retro-theme.nvim",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "retro-theme")
  vim.g.available_colorschemes = available_colorschemes
end

M.config = function()
  require("retro-theme").load()
end

return M
