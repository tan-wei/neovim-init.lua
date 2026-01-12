local M = {
  "rockerBOO/boo-colorscheme-nvim",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "boo")
  table.insert(available_colorschemes, "sunset_cloud")
  table.insert(available_colorschemes, "radioactive_waste")
  table.insert(available_colorschemes, "forest_stream")
  table.insert(available_colorschemes, "crimson_moonlight")
  vim.g.available_colorschemes = available_colorschemes
end

return M
