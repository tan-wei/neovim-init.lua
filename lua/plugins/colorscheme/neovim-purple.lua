local M = {
  "unrealjo/neovim-purple",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "neovim_purple")
  vim.g.available_colorschemes = available_colorschemes
end

return M
