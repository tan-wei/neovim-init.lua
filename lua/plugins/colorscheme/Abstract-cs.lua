local M = {
  "Abstract-IDE/Abstract-cs",
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "abscs")
  vim.g.available_colorschemes = available_colorschemes
end

return M