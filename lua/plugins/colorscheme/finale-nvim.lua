local M = {
  "https://gitlab.com/bartekjaszczak/finale-nvim",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "finale")
  vim.g.available_colorschemes = available_colorschemes
end

return M
