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
      },
    },
    animation = {
      enable = true,
      duration = 300,
      fps = 30,
      easing = "in_out_sine",
    },
  }

  local function cmd(command)
    return table.concat { "<Cmd>", command, "<CR>" }
  end

  vim.keymap.set("n", "<C-w>z", cmd "WindowsMaximize")
  vim.keymap.set("n", "<C-w>_", cmd "WindowsMaximizeVertically")
  vim.keymap.set("n", "<C-w>|", cmd "WindowsMaximizeHorizontally")
  vim.keymap.set("n", "<C-w>=", cmd "WindowsEqualize")
end

return M
