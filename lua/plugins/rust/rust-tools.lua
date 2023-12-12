local M = {
  "simrat39/rust-tools.nvim",
  dependencies = {
    "neovim/nvim-lspconfig",
    "nvim-lua/plenary.nvim",
    "mfussenegger/nvim-dap",
  },
  ft = "rust",
}

M.opts = {
  server = {
    interpret = {
      tests = true,
    },
  },
}

return M
