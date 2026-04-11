local M = {
  "sudoscrawl/tokyo-dark.nvim",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "tokyo-dark")
  vim.g.available_colorschemes = available_colorschemes
end

M.opts = {
  transparent = false,
  italic_comments = true,
}

return M
