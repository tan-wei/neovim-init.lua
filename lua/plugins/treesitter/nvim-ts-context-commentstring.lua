local M = {
  "JoosepAlviste/nvim-ts-context-commentstring",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  event = "VeryLazy",
}

M.init = function()
  vim.g.skip_ts_context_commentstring_module = true
end

M.config = function()
  require("ts_context_commentstring").setup {
    enable_autocmd = false,
  }
end

return M
