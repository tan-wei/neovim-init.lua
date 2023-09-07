local M = {
  "hachy/eva01.vim",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "eva01")
  table.insert(available_colorschemes, "eva01-LCL")
  vim.g.available_colorschemes = available_colorschemes
end

return M
