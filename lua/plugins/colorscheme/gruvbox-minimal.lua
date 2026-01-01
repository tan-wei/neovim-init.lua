local M = {
  "dybdeskarphet/gruvbox-minimal.nvim",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "gruvbox-minimal")
  vim.g.available_colorschemes = available_colorschemes
end

M.opts = {
  italic_comments = true,
  contrast = "high",
  theme = "dark",
  accent = "blue",
}

return M
