local M = {
  "b0o/nvim-tree-preview.lua",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "3rd/image.nvim",
  },
  lazy = true,
}

M.opts = {
  image_preview = {
    enable = true,
    patterns = {
      ".*%.avif$",
      ".*%.bmp$",
      ".*%.gif$",
      ".*%.heic$",
      ".*%.ico$",
      ".*%.jpeg$",
      ".*%.jpg$",
      ".*%.pdf$",
      ".*%.png$",
      ".*%.svg$",
      ".*%.webp$",
      ".*%.xpm$",
    },
  },
}

return M

