local M = {
  "mrcjkb/rustaceanvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "mfussenegger/nvim-dap",
  },
  ft = "rust",
}

M.config = function()
  vim.g.rustaceanvim = {
    server = {
      -- TODO: Fix this https://github.com/hrsh7th/cmp-nvim-lsp/issues/72
      capabilities = vim.lsp.protocol.make_client_capabilities(),
      on_attach = function(client, bufnr)
        require("user.lsp.handlers").on_attach(client, bufnr)
      end,
      settings = {
        ["rust-analyzer"] = {
          -- TODO
        },
      },
    },
    dap = {
      -- TODO
    },
  }
end

return M
