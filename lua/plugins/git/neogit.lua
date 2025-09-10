local M = {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
    "sindrets/diffview.nvim",
    "ibhagwan/fzf-lua",
  },
  cmd = { "Neogit", "NeogitLog", "NeogitCommit" },
}

M.opts = {
  graph_style = "unicode",
  kind = "floating",
}

return M
