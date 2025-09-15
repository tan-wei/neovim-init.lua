local M = {
  "stevearc/quicker.nvim",
  dependencies = {
    "kevinhwang91/nvim-bqf",
  },
  ft = "qf",
}

M.opts = {
  trim_leading_whitespace = "all",
  max_filename_width = function()
    return math.floor(math.min(50, vim.o.columns / 2))
  end,
}

return M
