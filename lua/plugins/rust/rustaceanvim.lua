local M = {
  "mrcjkb/rustaceanvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "mfussenegger/nvim-dap",
  },
  lazy = false,
}

M.init = function()
  vim.g.rustaceanvim = {
    server = {
      on_attach = function(client, bufnr)
        require("user.lsp.handlers").on_attach(client, bufnr)
      end,
      settings = {
        ["rust-analyzer"] = {
          diagnostics = {
            enable = true,
          },
        },
      },
    },
    dap = {
      -- TODO
    },
  }
end

return M
