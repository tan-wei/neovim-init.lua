local M = {
  "yegappan/mru",
}

M.init = function()
  vim.g.MRU_File = vim.fn.stdpath "data" .. "/.vim_mru_files"
end

return M
