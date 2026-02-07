local M = {
  "paul-han-gh/tomorrow.nvim",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "tomorrow-night")
  vim.g.available_colorschemes = available_colorschemes
end

M.config = function()
  require("tomorrow").setup()
end

return M
