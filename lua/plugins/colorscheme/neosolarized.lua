local M = {
  "svrana/neosolarized.nvim",
  dependencies = {
    "tjdevries/colorbuddy.nvim",
  },
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "neosolarized")
  vim.g.available_colorschemes = available_colorschemes
end

return M
