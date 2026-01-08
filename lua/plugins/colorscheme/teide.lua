local M = {
  "serhez/teide.nvim",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "teide-darker")
  table.insert(available_colorschemes, "teide-dark")
  table.insert(available_colorschemes, "teide-dimmed")
  vim.g.available_colorschemes = available_colorschemes
end

M.config = true

return M
