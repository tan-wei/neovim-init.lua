local M = {
  "nanotee/zoxide.vim",
  cmd = { "Z", "Lz", "Tz", "Zi", "Lzi", "Tzi" },
}

M.init = function()
  vim.g.zoxide_use_select = 1
end

return M
