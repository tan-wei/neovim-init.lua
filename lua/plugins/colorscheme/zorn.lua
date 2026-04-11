local M = {
  "anhari/zorn.nvim",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "zorn-dark")
  table.insert(available_colorschemes, "zorn-blue")
  table.insert(available_colorschemes, "zorn-umber")
  table.insert(available_colorschemes, "zorn-plum")
  vim.g.available_colorschemes = available_colorschemes
end

return M
