local M = {
  "chrisgrieser/nvim-justice",
  dependencies = {
    "folke/snacks.nvim",
  },
  cmd = "Justice",
}

M.opts = {
  recipeModes = {
    streaming = {
      name = {},
      comment = {},
    },
    terminal = {
      name = {},
      comment = {},
    },
    quickfix = {
      name = {},
      comment = {},
    },
    ignore = {
      name = {},
      comment = {},
    },
  },
}

return M
