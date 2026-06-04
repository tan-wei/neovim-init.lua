---@type LazyPluginSpec
local M = {
  "folke/edgy.nvim",
  event = "VeryLazy",
}

M.opts = {
  animate = { enabled = false },
  left = {
    {
      title = "NvimTree",
      ft = "NvimTree",
      size = { width = 30 },
      pinned = true,
      open = "NvimTreeOpen",
      wo = {
        winbar = true,
        winfixwidth = true,
        signcolumn = "no",
        spell = false,
        wrap = false,
      },
    },
  },
  bottom = {
    {
      title = "QuickFix",
      ft = "qf",
      size = { height = 0.25 },
      wo = {
        winbar = true,
        winfixheight = true,
        number = true,
        relativenumber = false,
        signcolumn = "number",
        spell = false,
        wrap = false,
      },
    },
  },
  right = {
    {
      title = "Outline",
      ft = "Outline",
      size = { width = 60 },
      pinned = true,
      open = "Outline",
      wo = {
        winbar = true,
        winfixwidth = true,
        signcolumn = "no",
        spell = false,
        wrap = false,
      },
    },
  },
}

return M
