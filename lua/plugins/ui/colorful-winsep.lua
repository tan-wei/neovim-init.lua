local M = {
  "nvim-zh/colorful-winsep.nvim",
  event = { "WinLeave" },
}

M.opts = {
  border = "rounded",
  excluded_ft = {
    "packer",
    "TelescopePrompt",
    "mason",
    "NvimTree",
    "alpha",
  },
}

return M
