local M = {
  "omacom-io/lumon.nvim",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "lumon")
  vim.g.available_colorschemes = available_colorschemes
end

return M
