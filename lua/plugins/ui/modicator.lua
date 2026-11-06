---@type LazyPluginSpec
local M = {
  "mawkler/modicator.nvim",
  dependencies = {
    "nvim-lualine/lualine.nvim",
  },
  event = "ModeChanged",
}

M.opts = {
  show_warnings = false,
  highlights = {
    defaults = {
      bold = true,
      italic = true,
    },
  },
  integration = {
    lualine = {
      enabled = true,
      mode_section = "a",
      highlight = "bg",
    },
  },
}

return M
