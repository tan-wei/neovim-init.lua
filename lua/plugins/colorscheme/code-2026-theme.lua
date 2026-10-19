---@type LazyPluginSpec
local M = {
  "code-2026-theme/nvim",
  name = "code-2026-theme",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "dark-2026")
  vim.g.available_colorschemes = available_colorschemes
end

M.config = function()
  require("code-2026").setup {
    background = "dark",
    dim_inactive = false,
  }
end

return M
