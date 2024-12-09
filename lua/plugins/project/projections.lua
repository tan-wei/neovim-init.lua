local M = {
  "GnikDroy/projections.nvim",
  event = "VeryLazy",
}

M.config = function()
  require("projections").setup {
    patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json" },
  }
end

return M
