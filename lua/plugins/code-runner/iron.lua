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
        sh = {
          command = { "zsh" },
        },
      },
      repl_open_cmd = require("iron.view").split.vertical "40%",
    },
    keymaps = {
      -- send_motion = "<space>sc",
      -- visual_send = "<space>sc",
      -- send_file = "<space>sf",
      -- send_line = "<space>sl",
      -- send_until_cursor = "<space>su",
      -- send_mark = "<space>sm",
      -- mark_motion = "<space>mc",
      -- mark_visual = "<space>mc",
      -- remove_mark = "<space>md",
      -- cr = "<space>s<cr>",
      -- interrupt = "<space>s<space>",
      -- exit = "<space>sq",
      -- clear = "<space>cl",
    },
    highlight = {
      italic = true,
    },
    ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
  }
end

-- TODO: Add it to which-key
-- vim.keymap.set("n", "<space>rs", "<cmd>IronRepl<cr>")
-- vim.keymap.set("n", "<space>rr", "<cmd>IronRestart<cr>")
-- vim.keymap.set("n", "<space>rf", "<cmd>IronFocus<cr>")
-- vim.keymap.set("n", "<space>rh", "<cmd>IronHide<cr>")

return M
