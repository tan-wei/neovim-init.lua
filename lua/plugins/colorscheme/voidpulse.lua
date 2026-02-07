local M = {
  "josstei/voidpulse.nvim",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "voidpulse")
  vim.g.available_colorschemes = available_colorschemes
end

M.config = function()
  require("voidpulse").setup()
end

return M
