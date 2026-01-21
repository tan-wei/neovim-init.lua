local M = {
  "projekt0n/github-nvim-theme",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "github_dark")
  table.insert(available_colorschemes, "github_dark_dimmed")
  table.insert(available_colorschemes, "github_dark_default")
  table.insert(available_colorschemes, "github_dark_high_contrast")
  table.insert(available_colorschemes, "github_dark_colorblind")
  table.insert(available_colorschemes, "github_dark_tritanopia")
  vim.g.available_colorschemes = available_colorschemes
end

return M
