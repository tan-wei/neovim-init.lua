local M = {
  "katawful/kat.nvim",
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "kat.nvim")
  table.insert(available_colorschemes, "kat.nwim")
  vim.g.available_colorschemes = available_colorschemes
end

return M
