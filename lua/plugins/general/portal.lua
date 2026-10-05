---@type LazyPluginSpec
local M = {
  "cbochs/portal.nvim",
  dependencies = {
    "cbochs/grapple.nvim",
    "ThePrimeagen/harpoon",
  },
  cmd = { "Portal" },
}

M.config = true

return M
