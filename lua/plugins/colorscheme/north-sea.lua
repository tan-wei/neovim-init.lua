local M = {
  "terkelg/north-sea.nvim",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "north-sea")
  vim.g.available_colorschemes = available_colorschemes
end

M.config = function()
  require("northsea").setup()
end

return M
