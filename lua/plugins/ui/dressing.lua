local M = {
  "stevearc/dressing.nvim",
  event = "VeryLazy",
}

M.opts = {
  input = {
    override = function(conf)
      conf.col = -1
      conf.row = 0
      return conf
    end,
  },
}

return M
