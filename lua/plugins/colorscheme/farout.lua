local M = {
  "thallada/farout.nvim",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "farout")
  table.insert(available_colorschemes, "farout-night")
  table.insert(available_colorschemes, "farout-moon")
  table.insert(available_colorschemes, "farout-storm")
  vim.g.available_colorschemes = available_colorschemes
end

return M
