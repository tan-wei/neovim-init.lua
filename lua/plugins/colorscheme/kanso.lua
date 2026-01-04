local M = {
  "webhooked/kanso.nvim",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "kanso")
  table.insert(available_colorschemes, "kanso-zen")
  table.insert(available_colorschemes, "kanso-ink")
  table.insert(available_colorschemes, "kanso-mist")
  vim.g.available_colorschemes = available_colorschemes
end

M.config = true

return M
