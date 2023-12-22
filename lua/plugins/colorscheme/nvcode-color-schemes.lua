local M = {
  "ChristianChiarulli/nvcode-color-schemes.vim",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "nvcode")
  table.insert(available_colorschemes, "snazzy")
  table.insert(available_colorschemes, "xoria")
  vim.g.available_colorschemes = available_colorschemes
end

return M
