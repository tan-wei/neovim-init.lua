local M = {
  "nyoom-engineering/oxocarbon.nvim",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "oxocarbon")
  vim.g.available_colorschemes = available_colorschemes
end

return M
