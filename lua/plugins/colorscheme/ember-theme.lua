local M = {
  "ember-theme/nvim",
  name = "ember",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "ember")
  table.insert(available_colorschemes, "ember-soft")
  vim.g.available_colorschemes = available_colorschemes
end

M.config = function()
  require("ember").setup {}
end

return M
