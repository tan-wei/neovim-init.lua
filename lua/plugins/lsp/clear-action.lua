local M = {
  "luckasRanarison/clear-action.nvim",
  event = "LspAttach",
}


M.config = {
  signs = {
    position = "eol",
    show_label = true,
    priority = 500,
  },
  popup = {
    enable = false,
  }
}

return M
