local M = {
  "nacro90/numb.nvim",
  event = { "CmdlineChanged" },
}

M.opts = {
  show_numbers = true,
  show_cursorline = true,
  hide_relativenumbers = true,
  number_only = false,
  centered_peeking = true,
}

return M
