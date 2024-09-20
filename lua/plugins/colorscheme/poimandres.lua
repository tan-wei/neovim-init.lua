local M = {
  "olivercederborg/poimandres.nvim",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "poimandres")
  vim.g.available_colorschemes = available_colorschemes
end

M.config = function()
  local p = require "poimandres.palette"
  require("poimandres").setup {
    highlight_groups = {
      CodeBlock = { bg = p.backgroud1 },
    },
  }
end

return M
