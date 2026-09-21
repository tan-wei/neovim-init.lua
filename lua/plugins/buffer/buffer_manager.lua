---@type LazyPluginSpec
local M = {
  "j-morano/buffer_manager.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  event = { "BufEnter" },
}

M.opts = {
  line_keys = "1234567890",
  select_menu_item_commands = {
    edit = {
      key = "<CR>",
      command = "edit",
    },
  },
  focus_alternate_buffer = false,
  width = nil,
  height = nil,
  short_file_names = false,
  show_depth = true,
  short_term_names = false,
  show_cols = "both", -- "kbs", "both"
  loop_nav = true,
  highlight = "",
  win_extra_options = {},
  borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
  format_function = nil,
  order_buffers = "lastused", -- "filename", "bufnr", "lastused", "fullpath"
  show_indicators = "before",
  toggle_key_bindings = { "q", "<ESC>" },
  use_shortcuts = false,
  win_position = { h = 0.5, v = 0.5 },
  quick_kbs = {
    enabled = false,
    kb = nil,
  },
}

return M
