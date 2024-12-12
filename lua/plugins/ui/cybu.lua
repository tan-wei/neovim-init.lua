local M = {
  "ghillb/cybu.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "nvim-lua/plenary.nvim",
  },
  event = "VeryLazy",
}

M.opts = {
  exclude = {
    "fugitive",
    "qf",
  },
}

return M
