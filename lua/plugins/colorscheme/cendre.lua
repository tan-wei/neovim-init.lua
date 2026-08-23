---@type LazyPluginSpec
local M = {
  "Aejkatappaja/cendre",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "cendre")
  vim.g.available_colorschemes = available_colorschemes
end

M.config = function()
  require("cendre").setup {
    background = "hard", -- "hard" | "medium" | "soft"
    italic_virtual_text = true,
  }
end

return M
