local M = {
  "github-main-user/lytmode.nvim",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "lytmode")
  vim.g.available_colorschemes = available_colorschemes
end

M.config = function()
  require("lytmode").setup()
end

return M
