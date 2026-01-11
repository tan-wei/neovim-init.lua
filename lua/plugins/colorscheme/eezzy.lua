local M = {
  "ashish2508/Eezzy.nvim",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "Eezzy")
  vim.g.available_colorschemes = available_colorschemes
end

M.config = function()
  require("Eezzy").setup {}
end

return M
