local M = {
  "ssstba/morta.nvim",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "morta")
  vim.g.available_colorschemes = available_colorschemes
end

M.config = true

return M
