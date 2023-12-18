local M = {
  "mawkler/modicator.nvim",
  event = "ModeChanged",
}

-- TODO: Now it works well, but if we change the colorschme, it will not work correctly
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
      mode_section = "b",
      highlight = "fg",
    },
  },
}

return M
