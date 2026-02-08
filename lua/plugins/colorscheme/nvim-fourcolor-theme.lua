local M = {
  "zanshin/nvim-fourcolor-theme",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "fourcolor")
  vim.g.available_colorschemes = available_colorschemes
end

return M
