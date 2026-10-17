---@type LazyPluginSpec
local M = {
  "daaanny90/iterm2-dark-background.nvim",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "iterm2-dark-background")
  vim.g.available_colorschemes = available_colorschemes
end

M.config = function()
  require("iterm2dark").setup()
end

return M
