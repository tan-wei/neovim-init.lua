local M = {
  "theamallalgi/zitchdog.vim",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "zitchdog")
  table.insert(available_colorschemes, "zitchdog-grape")
  table.insert(available_colorschemes, "zitchdog-pine")
  vim.g.available_colorschemes = available_colorschemes
end

return M
