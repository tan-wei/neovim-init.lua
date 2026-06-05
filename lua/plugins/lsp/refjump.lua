---@type LazyPluginSpec
local M = {
  "mawkler/refjump.nvim",
  event = "LspAttach",
}

M.opts = {
  keymaps = {
    enable = false,
  },
  integrations = {
    demicolon = {
      enable = true,
    },
  },
}

return M
