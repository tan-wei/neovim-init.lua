---@type LazyPluginSpec
local M = {
  "XXiaoA/atone.nvim",
  cmd = { "Atone" },
}

M.opts = {
  layout = {
    direction = "right",
    width = 60,
  },
  diff_cur_node = {
    enabled = true,
    split_percent = 0.3,
    width = "adaptive",
    treesitter = true,
    inline_diff = true,
  },
  auto_attach = {
    enabled = true,
    excluded_ft = { "oil" },
  },
  marks = {
    persist = true,
    persist_path = vim.fn.stdpath "data" .. "/atone_marks.json",
    finders = { "fzf-lua", "telescope", "builtin" },
  },
  diff_float = {
    autoclose = true,
  },
  ui = {
    compact = true,
    branch_symbols = "auto",
  },
}

return M
