local M = {
  "yorik1984/newpaper.nvim",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "newpaper")
  vim.g.available_colorschemes = available_colorschemes
end

M.config = function()
  require("newpaper").setup {
    style = "dark",
  }
end

return M
