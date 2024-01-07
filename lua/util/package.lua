local os = require "util.os"

local M = {}

M.is_loaded = function(name)
  return require("lazy.core.config").plugins[name]._.loaded
end

M.enabled_windows_only = function()
  return os.is_windows()
end

M.enabled_unix_only = function()
  return os.is_linux() or os.is_macos()
end

return M
