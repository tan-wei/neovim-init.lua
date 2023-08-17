local M = {
  "tanvirtin/monokai.nvim",
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "monokai")
  table.insert(available_colorschemes, "monokai_pro")
  table.insert(available_colorschemes, "monokai_soda")
  table.insert(available_colorschemes, "monokai_ristretto")
  vim.g.available_colorschemes = available_colorschemes
end

return M
