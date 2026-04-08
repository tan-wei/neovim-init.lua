local M = {
  "ray-x/lsp_signature.nvim",
  event = "VeryLazy",
}

M.config = function()
  require("lsp_signature").setup {
    log_path = vim.fn.stdpath "cache" .. "/lsp_signature.log",
    debug = false,
    handler_opts = { border = "rounded" },
    max_width = 80,
    ignore_error = function(_, ctx)
      local client = ctx and ctx.client_id and vim.lsp.get_client_by_id(ctx.client_id)
      return client and vim.tbl_contains({ "rust-analyzer", "clangd", "ccls" }, client.name) or false
    end,
  }
end

return M
