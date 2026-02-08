local M = {
  "shabaraba/yozakura.nvim",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "yozakura")
  vim.g.available_colorschemes = available_colorschemes
end

M.opts = {
  palette = "night_blue", -- "teal_night" | "warm_gray" | "muted_rose" | "night_blue"
}

return M
