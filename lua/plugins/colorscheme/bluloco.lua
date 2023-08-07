local M = {
  "uloco/bluloco.nvim",
  dependencies = {
    "rktjmp/lush.nvim",
  },
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "bluloco-dark")
  vim.g.available_colorschemes = available_colorschemes
end

return M
