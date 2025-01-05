local M = {
  "ab-dx/ares.nvim",
  dependencies = {
    "rktjmp/lush.nvim",
  },
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "ares")
  vim.g.available_colorschemes = available_colorschemes
end

return M
