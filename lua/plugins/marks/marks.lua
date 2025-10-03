local M = {
  "chentoast/marks.nvim",
  event = "VeryLazy",
}

M.opts = {
  default_mappings = true,
  builtin_marks = { ".", "<", ">", "^" },
  cyclic = true,
  force_write_shada = false,
  refresh_interval = 250,
  sign_priority = { lower = 10, upper = 15, builtin = 8, bookmark = 20 },
  excluded_filetypes = {
    "NvimTree",
  },
  excluded_buftypes = {
    "nofile",
    "prompt",
    "popup",
  },
  bookmark_0 = {
    sign = "⚑",
    virt_text = "Bookmark",
    annotate = true,
  },
  mappings = {},
}

return M
