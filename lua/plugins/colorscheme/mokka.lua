local M = {
  "dgrco/mokka.nvim",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "mokka")
  vim.g.available_colorschemes = available_colorschemes
end

M.opts = {
  variant = "mokka", -- "mokka" | "mariana"
}

return M
