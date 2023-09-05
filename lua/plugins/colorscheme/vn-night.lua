local M = {
  "nxvu699134/vn-night.nvim",
  lazy = true,
}

M.init = function()
  vim.g.one_allow_italics = 1
  local available_colorschemes = vim.g.available_colorschemes or {}
  -- table.insert(available_colorschemes, "vn-night") -- buggy now
  vim.g.available_colorschemes = available_colorschemes
end

return M
