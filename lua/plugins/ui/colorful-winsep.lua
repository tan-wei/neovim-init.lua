---@type LazyPluginSpec
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
    "checkhealth",
    "Outline",
    "toggleterm",
    "OverseerList",
    "OverseerForm",
    "qf",
    "help",
    "lazy",
    "noice",
    "notify",
    "trouble",
    "fugitive",
    "neogit",
    "undotree",
    "TelescopeResults",
    "dapui_breakpoint",
    "dapui_stacks",
    "dapui_scopes",
    "dapui_console",
    "dapui_watches",
  },
}

return M
