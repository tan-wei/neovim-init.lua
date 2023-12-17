local M = {
  "SmiteshP/nvim-navbuddy",
  dependencies = {
    "SmiteshP/nvim-navic",
    "MunifTanjim/nui.nvim",
    "neovim/nvim-lspconfig",
  },
  event = "LspAttach",
}

-- TODO: This plugin should write more configurations
M.config = true

return M
