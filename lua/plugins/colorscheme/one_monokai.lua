local M = {
  "cpea2506/one_monokai.nvim",
  lazy = true,
}

M.init = function()
  vim.g.onedark_termcolors = 256

  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "one_monokai")
  vim.g.available_colorschemes = available_colorschemes
end

return M
