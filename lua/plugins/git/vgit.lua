local M = {
  "tanvirtin/vgit.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  cmd = { "VGit" },
}

-- TODO: Keybindings should be configured with which-key
M.opts = {
  settings = {
    live_blame = {
      enabled = false,
    },
    live_gutter = {
      enabled = false,
    },
  },
}

return M
