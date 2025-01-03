local M = {
  "rose-pine/neovim",
  name = "rose-pine",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "rose-pine")
  table.insert(available_colorschemes, "rose-pine-main")
  table.insert(available_colorschemes, "rose-pine-moon")
  vim.g.available_colorschemes = available_colorschemes
end

return M
