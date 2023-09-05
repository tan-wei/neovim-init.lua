local M = {
  "EdenEast/nightfox.nvim",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "carbonfox")
  table.insert(available_colorschemes, "duskfox")
  table.insert(available_colorschemes, "nightfox")
  table.insert(available_colorschemes, "nordfox")
  table.insert(available_colorschemes, "terafox")
  vim.g.available_colorschemes = available_colorschemes
end

return M
