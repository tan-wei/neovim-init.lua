local M = {
  "f-person/git-blame.nvim",
  event = "VeryLazy",
}

-- TODO: Lualine integrate?
M.opts = {
  enabled = true,
  ignored_filetypes = {
    "markdown",
  },
  delay = 1000,
  use_blame_commit_file_urls = true,
}

return M
