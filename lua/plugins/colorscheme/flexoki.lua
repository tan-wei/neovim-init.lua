local M = {
  "kepano/flexoki-neovim",
  name = "flexoki",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "flexoki-dark")
  vim.g.available_colorschemes = available_colorschemes
end

return M
