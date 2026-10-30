---@type LazyPluginSpec
local M = {
  "thesimonho/kanagawa-paper",
  branch = "neovim",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "kanagawa-paper-ink")
  vim.g.available_colorschemes = available_colorschemes
end

M.config = true

return M
