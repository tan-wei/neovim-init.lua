local M = {
  "wuelnerdotexe/vim-enfocado",
  lazy = true,
}

M.init = function()
  vim.g.enfocado_style = "neon"
  vim.g.enfocado_plugins = { "all" }
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "enfocado")
  vim.g.available_colorschemes = available_colorschemes
end

return M
