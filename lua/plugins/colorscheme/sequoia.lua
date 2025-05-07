local M = {
  "forest-nvim/sequoia.nvim",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "sequoia")
  table.insert(available_colorschemes, "sequoia-night")
  table.insert(available_colorschemes, "sequoia-insomnia")
  vim.g.available_colorschemes = available_colorschemes
end

return M
