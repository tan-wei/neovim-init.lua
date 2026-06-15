---@type LazyPluginSpec
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
    motion = false,
  },
}

return M
