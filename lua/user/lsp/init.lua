local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
  return
end

require "user.lsp.mason"
require("user.lsp.handlers").setup()
require "user.lsp.null-ls"
require "user.lsp.lspsaga"
require "user.lsp.hlargs"
require "user.lsp.goto-preview"
require "user.lsp.aerial"
require "user.lsp.navbuddy"
require "user.lsp.lsp-lens"
