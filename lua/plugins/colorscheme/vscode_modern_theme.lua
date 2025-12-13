local M = {
  "gmr458/vscode_modern_theme.nvim",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "vscode_modern")
  vim.g.available_colorschemes = available_colorschemes
end

M.config = function()
  require("vscode_modern").setup {
    cursorline = true,
    transparent_background = false,
    nvim_tree_darker = true,
  }
end

return M
