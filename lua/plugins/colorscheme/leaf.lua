local M = {
  "daschw/leaf.nvim",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "leaf")
  vim.g.available_colorschemes = available_colorschemes
end

M.opts = {
  contrast = "high",
}

return M
