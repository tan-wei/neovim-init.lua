local M = {
  "pablobfonseca/cyberpunk-theme",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "cyberpunk")
  vim.g.available_colorschemes = available_colorschemes
end

M.config = function()
  require("cyberpunk").setup()
end

return M
