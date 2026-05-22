---@type table<string, fun(...: any): any>
local M = {}

local get_os_name = function()
  return vim.uv.os_uname().sysname
end

local function to_positive_integer(value)
  local number = tonumber(value)

  if not number or number < 1 then
    return nil
  end

  return math.floor(number)
end

local function read_command_integer(command)
  local handle = io.popen(command)
  if not handle then
    return nil
  end

  local ok, result = pcall(handle.read, handle, "*a")
  handle:close()

  if not ok then
    return nil
  end

  return to_positive_integer(result)
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

M.get_cpu_count = function()
  if type(vim.uv.available_parallelism) == "function" then
    local ok, value = pcall(vim.uv.available_parallelism)
    local count = ok and to_positive_integer(value) or nil
    if count then
      return count
    end
  end

  local env_count = to_positive_integer(os.getenv "NUMBER_OF_PROCESSORS")
  if env_count then
    return env_count
  end

  if M.is_linux() then
    return read_command_integer "nproc" or 1
  end

  if M.is_macos() then
    return read_command_integer "sysctl -n hw.ncpu" or 1
  end

  return 1
end

M.get_parallel_job_count = function(divisor, minimum)
  local safe_divisor = to_positive_integer(divisor) or 1
  local safe_minimum = to_positive_integer(minimum) or 1
  return math.max(safe_minimum, math.floor(M.get_cpu_count() / safe_divisor))
end

return M
