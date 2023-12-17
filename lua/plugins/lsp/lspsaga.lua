local M = {
  "nvimdev/lspsaga.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  event = "LspAttach",
}

M.opts = {
  ui = {
    code_action = "",
  },

  symbol_in_winbar = {
    enable = false,
  },
}

return M
