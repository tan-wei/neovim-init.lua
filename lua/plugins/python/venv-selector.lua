local M = {
  "linux-cultist/venv-selector.nvim",
  branch = "regexp",
  dependencies = {
    "neovim/nvim-lspconfig",
    "mfussenegger/nvim-dap",
    "mfussenegger/nvim-dap-python",
    "nvim-telescope/telescope.nvim",
  },
  lazy = false,
}

-- TODO: This plugin should write more configurations
M.config = true

return M
