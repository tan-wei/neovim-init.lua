local M = {
  "NMAC427/guess-indent.nvim",
  event = "BufEnter",
}

M.opts = {
  auto_cmd = true,
  override_editorconfig = false,
  filetype_exclude = {
    "netrw",
    "tutor",
    "NvimTree",
  },
  buftype_exclude = {
    "help",
    "nofile",
    "terminal",
    "prompt",
  },
}

return M
