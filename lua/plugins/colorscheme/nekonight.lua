local M = {
  "BrunoCiccarino/nekonight",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "nekonight-night")
  table.insert(available_colorschemes, "nekonight-storm")
  table.insert(available_colorschemes, "nekonight-moon")
  vim.g.available_colorschemes = available_colorschemes
end

M.config = true

return M
