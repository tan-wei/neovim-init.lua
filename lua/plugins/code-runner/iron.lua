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
      -- TODO: Mark related keymap should be configured
      -- send_motion = "<space>rs",
      -- visual_send = "<space>rs",
      -- send_file = "<space>rf",
      -- send_line = "<space>rl",
      -- send_until_cursor = "<space>ru",
      -- send_mark = "<space>sm",
      -- mark_motion = "<space>mc",
      -- mark_visual = "<space>mc",
      -- remove_mark = "<space>md",
      cr = "<space>s<cr>",
      interrupt = "<space>s<space>",
      exit = "<space>sq",
      clear = "<space>cl",
    },
    highlight = {
      italic = true,
    },
    ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
  }
end

return M
