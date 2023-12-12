local M = {
  "lukas-reineke/headlines.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  ft = { "markdown", "orgmode", "neorg" },
}

M.opts = {
  markdown = {
    headline_highlights = false,
  },
}

return M
