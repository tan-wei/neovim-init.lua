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
