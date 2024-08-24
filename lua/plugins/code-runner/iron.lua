local M = {
  "Vigemus/iron.nvim",
  cmd = {
    "IronRepl",
    "IronRestart",
    "IronFocus",
    "IronHide",
  },
}

M.config = function()
  require("iron.core").setup {
    config = {
      scratch_repl = true,
      repl_definition = {
        -- NOTE: Define our own REPL here
      },
      repl_open_cmd = require("iron.view").split.vertical "40%",
    },
    keymaps = {
      send_motion = "",
      visual_send = "",
      send_file = "",
      send_line = "",
      send_until_cursor = "",
      send_mark = "",
      mark_motion = "",
      mark_visual = "",
      remove_mark = "",
      cr = "",
      interrupt = "",
      exit = "",
      clear = "",
    },
    highlight = {
      italic = true,
    },
    ignore_blank_lines = true,
  }
end

return M
