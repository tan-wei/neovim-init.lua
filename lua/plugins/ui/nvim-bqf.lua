local M = {
  "kevinhwang91/nvim-bqf",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "junegunn/fzf",
  },
  ft = "qf",
}

M.config = function()
  require("bqf").setup {
    auto_enable = true,
    auto_resize_height = true,
    preview = {
      auto_preview = false,
    },
  }
end

return M
