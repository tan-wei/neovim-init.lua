local M = {
  "Zeioth/garbage-day.nvim",
  dependencies = {
    "neovim/nvim-lspconfig",
  },
  event = "LspAttach",
}

M.opts = {
  aggressive_mode_ignore = false,
  notifications = true,
  excluded_lsp_clients = {},
  grace_period = 30 * 60,
}

return M
