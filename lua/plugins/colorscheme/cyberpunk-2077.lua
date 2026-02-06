local M = {
  "followLemmi/cyberpunk-2077.nvim",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "cyberpunk-2077")
  vim.g.available_colorschemes = available_colorschemes
end

M.config = function()
  require("cyberpunk-2077").setup()
end

return M
