local M = {
  "SmiteshP/nvim-navbuddy",
  dependencies = {
    "SmiteshP/nvim-navic",
    "MunifTanjim/nui.nvim",
    "neovim/nvim-lspconfig",
  },
  event = "LspAttach",
}

M.init = function()
  vim.g.navbuddy_silence = true
end

-- TODO: This plugin should write more configurations
M.config = true

return M
