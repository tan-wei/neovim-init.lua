local M = {
  "dhruvasagar/vim-table-mode",
  cmd = "TableModeToggle",
}

M.init = function()
  vim.g.table_mode_corner = "|"
end

M.config = function()
  vim.o.commentstring = "<!-- %%s -->"
end

return M
