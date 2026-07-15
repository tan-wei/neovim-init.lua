---@type LazyPluginSpec
local M = {
  "mikavilpas/yazi.nvim",
  dependencies = {
    "folke/snacks.nvim",
  },
  cmd = { "Yazi" },
}

M.opts = {
  yazi_floating_window_winblend = 10,
  yazi_floating_window_border = "rounded",
  floating_window_scaling_factor = 0.9,
  integrations = {
    grep_in_directory = function(directory)
      require("grug-far").open {
        prefills = {
          paths = directory,
        },
      }
    end,
    grep_under_cursor = function()
      local word = vim.fn.expand "<cword>"
      require("grug-far").open {
        prefills = {
          search = word,
        },
      }
    end,
  },
  keymaps = {
    show_help = "<F1>",
    grep_under_cursor = "<a-g>",
    open_file_in_vertical_split = "<c-v>",
    open_file_in_horizontal_split = "<c-x>",
    open_file_in_tab = "<c-t>",
    grep_in_directory = "<c-s>",
    replace_in_directory = "<c-g>",
    cycle_open_buffers = "<tab>",
    copy_relative_path_to_selected_files = "<c-y>",
    send_to_quickfix_list = "<c-q>",
    change_working_directory = "<c-\\>",
    open_and_pick_window = "<c-o>",
  },

  open_file_function = function(entry, _config, _state)
    vim.cmd("edit " .. vim.fn.fnamescape(entry.path))
  end,
}

return M
