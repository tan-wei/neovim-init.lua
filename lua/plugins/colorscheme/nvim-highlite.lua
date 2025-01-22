local M = {
  "Iron-E/nvim-highlite",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "highlite")
  table.insert(available_colorschemes, "highlite-ayu")
  table.insert(available_colorschemes, "highlite-everforest")
  table.insert(available_colorschemes, "highlite-gruvbox")
  table.insert(available_colorschemes, "highlite-gruvbox-material")
  table.insert(available_colorschemes, "highlite-iceberg")
  table.insert(available_colorschemes, "highlite-molokai")
  table.insert(available_colorschemes, "highlite-papercolor")
  table.insert(available_colorschemes, "highlite-seoul256")
  table.insert(available_colorschemes, "highlite-solarized8")
  table.insert(available_colorschemes, "highlitesonokai")
  vim.g.available_colorschemes = available_colorschemes
end

return M
