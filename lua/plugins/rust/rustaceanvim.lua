local M = {
  "mrcjkb/rustaceanvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "mfussenegger/nvim-dap",
  },
  ft = "rust",
  cmd = "RustLsp",
}

return M
