local os = require "util.os"

local M = {}

M.is_loaded = function(name)
  local plugins = require("lazy.core.config").plugins
  if plugins[name] then
    return plugins[name]._.loaded
  end
  return false
end

M.enabled_windows_only = function()
  return os.is_windows()
end

M.enabled_unix_only = function()
  return os.is_linux() or os.is_macos()
end

return M
