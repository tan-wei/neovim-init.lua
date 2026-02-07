local M = {
  "srt0/codescope.nvim",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "codescope")
  vim.g.available_colorschemes = available_colorschemes
end

M.config = function()
  require("codescope").setup()
end

return M
