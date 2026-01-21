local M = {
  "casedami/neomodern.nvim",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "iceclimber")
  table.insert(available_colorschemes, "gyokuro")
  table.insert(available_colorschemes, "hojicha")
  table.insert(available_colorschemes, "roseprime")
  vim.g.available_colorschemes = available_colorschemes
end

M.config = true

return M
