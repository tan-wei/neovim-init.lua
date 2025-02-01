local M = {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  ft = { "markdown", "quarto" },
}

M.opts = {
  enabled = false,
}

return M
