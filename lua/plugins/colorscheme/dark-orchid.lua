local M = {
  "dark-orchid/neovim",
  name = "dark-orchid",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "dark-orchid")
  vim.g.available_colorschemes = available_colorschemes
end

M.config = function()
  require("dark-orchid").setup()
end

return M
