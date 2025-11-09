local M = {
  "wurli/visimatch.nvim",
  event = "VeryLazy",
}

M.opts = {
  chars_lower_limit = 3,
  lines_upper_limit = 40,
  strict_spacing = false,
  buffers = "filetype", -- filetype, current, all
  case_insensitive = { "markdown", "text", "help" },
}

return M
