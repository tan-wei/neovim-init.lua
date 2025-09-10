local M = {
  "chrisbra/csv.vim",
}

M.config = function()
  vim.g.csv_no_column_highlight = 1
  vim.g.csv_highlight_column = 0
end

return M
