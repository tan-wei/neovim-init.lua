local M = {
  "ATTron/bebop.nvim",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "bebop")
  vim.g.available_colorschemes = available_colorschemes
end

M.opts = {
  transparent = false,
  terminal_colors = true,
  preset = "spike", -- "default", "spike", or "faye"
}

return M
