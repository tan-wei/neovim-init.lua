

local M = {
  "yonlu/omni.vim",
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "omni")
  vim.g.available_colorschemes = available_colorschemes
end

return M
