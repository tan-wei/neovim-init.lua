---@type { setup: fun() }
local M = {}

M.setup = function()
  require("user.keymap.registry").apply_plain()
end

return M
