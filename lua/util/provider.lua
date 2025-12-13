local M = {}

M.executable_exist = function(executable)
  return vim.fn.executable(executable) == 1
end

M.image_protocol_support = function()
  return require("util.client").is_kitty() or require("util.client").is_ghostty() or require("util.client").is_wezterm()
end

return M
