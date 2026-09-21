---@type LazyPluginSpec
local M = {
  "anuvyklack/windows.nvim",
  dependencies = {
    "anuvyklack/middleclass",
    "anuvyklack/animation.nvim",
  },
  cmd = {
    "WindowsMaximize",
    "WindowsMaximizeVertically",
    "WindowsMaximizeHorizontally",
    "WindowsEqualize",
    "WindowsEnableAutowidth",
    "WindowsDisableAutowidth",
    "WindowsToggleAutowidth",
  },
}

M.config = function()
  require("windows").setup {
    autowidth = {
      enable = false,
      winwidth = 5,
      filetype = {},
    },
    ignore = {
      buftype = {
        "quickfix",
      },
      filetype = {
        "NvimTree",
        "neo-tree",
        "undotree",
        "gundo",
        "qf",
      },
    },
    animation = {
      enable = true,
      duration = 300,
      fps = 30,
      easing = "in_out_sine",
    },
  }
end

M.keys = require("user.keymap.registry").lazy_keys "windows.nvim"

return M
