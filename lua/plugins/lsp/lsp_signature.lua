local M = {
  "ray-x/lsp_signature.nvim",
  event = "VeryLazy",
}

M.config = function()
  require("lsp_signature").setup {
    log_path = vim.fn.stdpath "cache" .. "/lsp_signature.log",
    debug = true,
    handler_opts = { border = "rounded" },
    max_width = 80,
    noice = false, -- TODO: Will cause error, and the author consider to deprecate this option
    ignore_error = function(err, ctx, config)
      local client = vim.lsp.get_client_by_id(ctx.client_id)
      if client and vim.tbl_contains({ "rust_analyer", "clangd", "ccls" }, client.name) then
        return true
      end

      if vim.tbl_contains({}, err.code_name) then
        return true
      end
    end,
  }
end

return M
