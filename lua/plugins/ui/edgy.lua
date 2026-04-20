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
  bottom = {},
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
