local M = {
  "sugiura-hiromiti/primary.nvim",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "primary")
  vim.g.available_colorschemes = available_colorschemes
end

return M
