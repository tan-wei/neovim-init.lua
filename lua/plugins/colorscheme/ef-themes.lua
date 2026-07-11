---@type LazyPluginSpec
local M = {
  "oonamo/ef-themes.nvim",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "ef-autumn")
  table.insert(available_colorschemes, "ef-bio")
  table.insert(available_colorschemes, "ef-cherie")
  table.insert(available_colorschemes, "ef-dark")
  table.insert(available_colorschemes, "ef-dream")
  table.insert(available_colorschemes, "ef-duo-dark")
  table.insert(available_colorschemes, "ef-elea-dark")
  table.insert(available_colorschemes, "ef-maris-dark")
  table.insert(available_colorschemes, "ef-melissa-dark")
  table.insert(available_colorschemes, "ef-night")
  table.insert(available_colorschemes, "ef-owl")
  table.insert(available_colorschemes, "ef-rosa")
  table.insert(available_colorschemes, "ef-symbiosis")
  table.insert(available_colorschemes, "ef-trio-dark")
  table.insert(available_colorschemes, "ef-tritanopia-dark")
  table.insert(available_colorschemes, "ef-winter")
  vim.g.available_colorschemes = available_colorschemes
end

return M
