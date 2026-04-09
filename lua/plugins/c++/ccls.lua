local M = {
  "ranjithshegde/ccls.nvim",
  ft = { "c", "cpp", "objc", "objcpp" },
  config = function()
    -- Only initialize tree/hierarchy UI features.
    -- LSP setup is handled via vim.lsp.config/vim.lsp.enable in nvim-lspconfig.
    require("ccls").setup {}
  end,
}

return M
