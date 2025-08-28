local M = {
  "sQVe/sort.nvim",
  event = "VeryLazy",
}

M.opts = {
  delimiters = {
    ",",
    "|",
    ";",
    ":",
    "s", -- Space
    "t", -- Tab
  },
  mappings = {
    operator = "go",
    textobject = {
      inner = "io",
      around = "ao",
    },
    motion = {
      next_delimiter = "]o",
      prev_delimiter = "[o",
    },
  },
}

return M
