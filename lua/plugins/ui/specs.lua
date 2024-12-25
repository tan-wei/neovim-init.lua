local M = {
  "cxwx/specs.nvim",
  event = "VeryLazy",
  enabled = false,
}

M.config = function()
  require("specs").setup {
    show_jumps = true,
    min_jump = 30,
    popup = {
      delay_ms = 0,
      inc_ms = 10,
      blend = 10,
      width = 10,
      winhl = "PMenu",
      fader = require("specs").pulse_fader,
      resizer = require("specs").shrink_resizer,
    },
    ignore_filetypes = {},
    ignore_buftypes = {
      nofile = true,
    },
  }
end

return M
