local M = {}

M.executable_exist = function(executable)
  return vim.fn.executable(executable) == 1
end

return M
