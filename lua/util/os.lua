local M = {}

local get_os_name = function()
  return vim.uv.os_uname().sysname
end

M.is_windows = function()
  if get_os_name() == "Windows_NT" then
    return true
  else
    return false
  end
end

M.is_wsl = function()
  return vim.fn.has "wsl" == 1 or os.getenv "WSL_DISTRO_NAME" ~= nil
end

M.is_macos = function()
  if get_os_name() == "Darwin" then
    return true
  else
    return false
  end
end

M.is_linux = function()
  if get_os_name() == "Linux" then
    return true
  else
    return false
  end
end

return M
