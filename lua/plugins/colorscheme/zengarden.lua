local M = {
  "tobi-wan-kenobi/zengarden",
  dependencies = {
    "rktjmp/lush.nvim",
  },
  lazy = true,
}

M.setup = function()
  require("zengarden").setup {
    variant = "yellow",
  }
end

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "zengarden")
  vim.g.available_colorschemes = available_colorschemes
end

return M
