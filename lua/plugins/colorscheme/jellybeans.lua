local M = {
  "nanotech/jellybeans.vim",
  lazy = true,
}

M.init = function()
  vim.g.jellybeans_use_term_italics = 1

  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "jellybeans")
  vim.g.available_colorschemes = available_colorschemes
end

return M
