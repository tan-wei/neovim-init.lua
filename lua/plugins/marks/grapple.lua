---@type LazyPluginSpec
local M = {
  "cbochs/grapple.nvim",
  cmd = {
    "Grapple",
    "GrappleTag",
    "GrappleUntag",
    "GrappleToggle",
    "GrappleCycle",
    "GrappleSelect",
    "GrappleReset",
    "GrapplePopup",
  },
}

M.config = true

return M
