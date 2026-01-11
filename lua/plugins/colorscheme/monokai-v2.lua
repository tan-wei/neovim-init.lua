local M = {
  "khoido2003/monokai-v2.nvim",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "monokai-v2")
  vim.g.available_colorschemes = available_colorschemes
end

M.config = function()
  require("monokai-v2").setup()
end

return M
