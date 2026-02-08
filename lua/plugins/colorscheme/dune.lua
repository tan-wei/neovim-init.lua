local M = {
  "szammyboi/dune.nvim",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "dune")
  table.insert(available_colorschemes, "arrakis")
  table.insert(available_colorschemes, "caladan")
  table.insert(available_colorschemes, "chapterhouse")
  vim.g.available_colorschemes = available_colorschemes
end

return M
