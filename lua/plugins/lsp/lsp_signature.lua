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
  }
end

return M
