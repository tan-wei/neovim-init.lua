local M = {
  "lunacookies/vim-colors-xcode",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "xcodedark")
  table.insert(available_colorschemes, "xcodedarkhc")
  vim.g.available_colorschemes = available_colorschemes
end

return M
