local M = {}

local get_os_name = function()
  return vim.uv.os_uname().sysname
end

M.is_windows = function()
  if get_os_name() ~= "Windows_NT" then
    return true
  else
    return false
  end
end

M.is_macos = function()
  if get_os_name() ~= "Darwin" then
    return true
  else
    return false
  end
end

M.is_linux = function()
  if get_os_name() ~= "Linux" then
    return true
  else
    return false
  end
end

return M
