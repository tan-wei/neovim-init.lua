local M = {
  "folke/todo-comments.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "folke/trouble.nvim",
    "nvim-telescope/telescope.nvim",
  },
  -- cmd = "VeryLazy", It will not work after LSP is attached, so disable the event
}

M.opts = {
  keywords = {
    FIX = {
      icon = " ",
      color = "error",
      alt = { "FIXME", "BUG", "FIXIT", "ISSUE" },
    },
    TODO = { icon = "", color = "info" },
    HACK = { icon = " ", color = "warning" },
    WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
    PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
    NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
    TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
  },
  highlight = {
    exclude = {},
  },
  search = {
    pattern = [[\b(KEYWORDS):+]],
  },
}

return M
