local M = {
  "Abstract-IDE/Abstract-cs",
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  -- table.insert(available_colorschemes, "abscs")  -- Not set vim.g.colors, buggy
  vim.g.available_colorschemes = available_colorschemes
end

return M
