local M = {
  "dhruvasagar/vim-table-mode",
  cmd = "TableModeToggle",
}

M.init = function()
  vim.g.table_mode_corner = "|"
end

return M
