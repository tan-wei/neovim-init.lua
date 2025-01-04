local M = {
  "vague2k/vague.nvim",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "vauge")
  vim.g.available_colorschemes = available_colorschemes
end

M.opts = true

return M
