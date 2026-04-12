local M = {
  "0x-ximon/acario.nvim",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "acario_dark")
  vim.g.available_colorschemes = available_colorschemes
end

return M
